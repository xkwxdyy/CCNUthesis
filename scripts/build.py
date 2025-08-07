#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
CCNUthesis Build Script
Build and package CCNUthesis LaTeX template

Usage:
    python build.py [version] [options]
    
Options:
    --skip-compile    Skip LaTeX compilation
    --skip-docs       Skip documentation building
    --debug           Enable debug output
"""

import os
import sys
import shutil
import subprocess
import argparse
import re
import zipfile
import logging
from pathlib import Path
from datetime import datetime
from typing import Optional, List, Tuple


# Configure logging
def setup_logging(debug: bool = False):
    """Set up logging configuration."""
    level = logging.DEBUG if debug else logging.INFO
    logging.basicConfig(
        level=level,
        format='%(asctime)s - %(levelname)s - %(message)s',
        datefmt='%H:%M:%S'
    )
    return logging.getLogger(__name__)


class CCNUthesisBuild:
    """CCNUthesis build manager."""
    
    def __init__(self, base_dir: Optional[Path] = None, debug: bool = False):
        """Initialize build manager."""
        self.logger = setup_logging(debug)
        self.base_dir = base_dir or Path(__file__).parent.parent.resolve()
        self.source_dir = self.base_dir / "source"
        self.test_dir = self.base_dir / "test"
        self.docs_dir = self.base_dir / "docs" / "user-guide"
        self.release_dir = self.base_dir / "release"
        self.assets_dir = self.base_dir / "assets"
        
        # File lists
        self.cls_file = "CCNUthesis.cls"
        self.doc_files = ["CCNUthesis-doc.tex", "CCNUthesis-doc.pdf"]
        self.example_files = [
            "main.tex", "main.pdf", "ccnu-setup.tex",
            "CCNUthesis-main.bib"
        ]
        self.bib_files = [
            "gb7714-CCNU.bbx", "gb7714-CCNU.cbx",
            "gb7714-CCNUay.bbx", "gb7714-CCNUay.cbx"
        ]
        self.help_files = [
            "README.md", "CHANGELOG.md", "LICENSE",
            "latexmkrc", "lguide-ch1.pdf"
        ]
        self.sub_dirs = ["front", "body", "back"]
        
        # Regex patterns for version updates
        self.patterns = {
            'cls': re.compile(
                r'\\ProvidesExplClass\s*\{[^}]*\}\s*\{([^}]*)\}\s*\{v([^}]*)\}'
            ),
            'tex_date': re.compile(r'% update date: \d{4}-\d{2}-\d{2}'),
            'tex_version': re.compile(r'% version: v[\d.]+'),
            'doc_date': re.compile(r'\\newcommand\{\\DocDate\}\{([^}]*)\}'),
            'doc_version': re.compile(r'\\newcommand\{\\DocVersion\}\{v([^}]*)\}'),
        }
        
    def get_version_from_user(self, version: Optional[str] = None) -> str:
        """Get version number from user input."""
        if version:
            confirm = input(f"New version will be: v{version}. Confirm? [y/N]: ")
            if confirm.lower() == 'y':
                return version
        
        while True:
            version = input("Please enter the new version number (e.g., 1.4.7): ")
            confirm = input(f"New version will be: v{version}. Confirm? [y/N]: ")
            if confirm.lower() == 'y':
                return version
                
    def update_version(self, version: str) -> bool:
        """Update version in all relevant files."""
        date_str = datetime.now().strftime('%Y-%m-%d')
        self.logger.info(f"Updating to version {version} ({date_str})")
        
        try:
            # Update CCNUthesis.cls
            cls_path = self.source_dir / self.cls_file
            if cls_path.exists():
                content = cls_path.read_text(encoding='utf-8')
                content = self.patterns['cls'].sub(
                    f'\\\\ProvidesExplClass {{CCNUthesis}} {{{date_str}}} {{v{version}}}',
                    content
                )
                cls_path.write_text(content, encoding='utf-8')
                self.logger.debug(f"Updated {cls_path}")
            
            # Update main.tex in test-basic
            main_path = self.test_dir / "test-basic" / "main.tex"
            if main_path.exists():
                content = main_path.read_text(encoding='utf-8')
                content = self.patterns['tex_date'].sub(
                    f'% update date: {date_str}', content
                )
                content = self.patterns['tex_version'].sub(
                    f'% version: v{version}', content
                )
                main_path.write_text(content, encoding='utf-8')
                self.logger.debug(f"Updated {main_path}")
            
            # Update documentation
            doc_tex_path = self.docs_dir / "CCNUthesis-doc.tex"
            if doc_tex_path.exists():
                content = doc_tex_path.read_text(encoding='utf-8')
                content = self.patterns['doc_date'].sub(
                    f'\\\\newcommand{{\\\\DocDate}}{{{date_str}}}', content
                )
                content = self.patterns['doc_version'].sub(
                    f'\\\\newcommand{{\\\\DocVersion}}{{v{version}}}', content
                )
                doc_tex_path.write_text(content, encoding='utf-8')
                self.logger.debug(f"Updated {doc_tex_path}")
                
            # Update CHANGELOG.md
            self.update_changelog(version, date_str)
            
            return True
            
        except Exception as e:
            self.logger.error(f"Failed to update version: {e}")
            return False
            
    def update_changelog(self, version: str, date_str: str):
        """Update CHANGELOG.md with new version entry."""
        changelog_path = self.base_dir / "CHANGELOG.md"
        if not changelog_path.exists():
            return
            
        content = changelog_path.read_text(encoding='utf-8')
        
        # Check if version already exists
        if f"## v{version}" in content:
            self.logger.info(f"Version v{version} already in CHANGELOG.md")
            return
            
        # Add new version entry after the header
        lines = content.split('\n')
        insert_idx = 0
        
        # Find the position after the title and description
        for i, line in enumerate(lines):
            if line.startswith('## '):
                insert_idx = i
                break
                
        # Create new version entry
        new_entry = [
            f"## v{version} ({date_str})",
            "",
            "### Added",
            "- ",
            "",
            "### Changed",
            "- ",
            "",
            "### Fixed",
            "- ",
            "",
        ]
        
        # Insert new entry
        lines[insert_idx:insert_idx] = new_entry
        
        # Write back
        changelog_path.write_text('\n'.join(lines), encoding='utf-8')
        self.logger.info("Updated CHANGELOG.md")
        
    def compile_latex(self, tex_file: Path, work_dir: Path) -> bool:
        """Compile LaTeX file using latexmk."""
        self.logger.info(f"Compiling {tex_file.name}...")
        
        try:
            result = subprocess.run(
                ['latexmk', '-xelatex', str(tex_file)],
                cwd=work_dir,
                capture_output=True,
                text=True,
                timeout=120
            )
            
            if result.returncode == 0:
                self.logger.info(f"✓ Successfully compiled {tex_file.name}")
                return True
            else:
                self.logger.error(f"✗ Failed to compile {tex_file.name}")
                if result.stderr:
                    self.logger.debug(result.stderr)
                return False
                
        except subprocess.TimeoutExpired:
            self.logger.error(f"Compilation timeout for {tex_file.name}")
            return False
        except FileNotFoundError:
            self.logger.error("latexmk not found. Please install TeX distribution.")
            return False
        except Exception as e:
            self.logger.error(f"Compilation error: {e}")
            return False
            
    def build_documentation(self) -> bool:
        """Build user documentation."""
        doc_tex = self.docs_dir / "CCNUthesis-doc.tex"
        
        if not doc_tex.exists():
            self.logger.warning("Documentation source not found")
            return False
            
        return self.compile_latex(doc_tex, self.docs_dir)
        
    def build_example(self) -> bool:
        """Build example document."""
        example_dir = self.test_dir / "test-basic"
        main_tex = example_dir / "main.tex"
        
        if not main_tex.exists():
            self.logger.warning("Example source not found")
            return False
            
        return self.compile_latex(main_tex, example_dir)
        
    def prepare_release_files(self, version: str) -> Path:
        """Prepare files for release."""
        release_version_dir = self.release_dir / f"CCNUthesis-v{version}"
        
        # Clean and create release directory
        if release_version_dir.exists():
            shutil.rmtree(release_version_dir)
        release_version_dir.mkdir(parents=True, exist_ok=True)
        
        self.logger.info(f"Preparing release in {release_version_dir}")
        
        # Copy source files
        self.logger.debug("Copying source files...")
        shutil.copy2(self.source_dir / self.cls_file, release_version_dir)
        for bib_file in self.bib_files:
            src = self.source_dir / bib_file
            if src.exists():
                shutil.copy2(src, release_version_dir)
        
        # Copy example files
        self.logger.debug("Copying example files...")
        example_dir = self.test_dir / "test-basic"
        for example_file in self.example_files:
            src = example_dir / example_file
            if src.exists():
                shutil.copy2(src, release_version_dir)
        
        # Copy subdirectories
        for sub_dir in self.sub_dirs:
            src_dir = example_dir / sub_dir
            if src_dir.exists():
                shutil.copytree(src_dir, release_version_dir / sub_dir)
        
        # Copy asset directories
        self.logger.debug("Copying assets...")
        assets_mapping = {
            "assets/images/logos": "logo",
            "assets/images/figures": "figures",
            "assets/documents/copyright": "copyright"
        }
        
        for src_path, dst_name in assets_mapping.items():
            src_dir = self.base_dir / src_path
            if src_dir.exists():
                shutil.copytree(src_dir, release_version_dir / dst_name)
        
        # Copy documentation and help files
        self.logger.debug("Copying documentation...")
        doc_pdf = self.docs_dir / "CCNUthesis-doc.pdf"
        if doc_pdf.exists():
            shutil.copy2(doc_pdf, release_version_dir)
            
        for help_file in self.help_files:
            src = self.base_dir / help_file
            if help_file == "latexmkrc":
                src = self.base_dir / "scripts" / help_file
            if src.exists():
                shutil.copy2(src, release_version_dir)
        
        # Update paths in release files
        self.update_release_paths(release_version_dir)
        
        return release_version_dir
        
    def update_release_paths(self, release_dir: Path):
        """Update file paths for release version."""
        self.logger.debug("Updating paths for release...")
        
        # Update main.tex
        main_tex = release_dir / "main.tex"
        if main_tex.exists():
            content = main_tex.read_text(encoding='utf-8')
            content = content.replace('../../source/CCNUthesis', 'CCNUthesis')
            main_tex.write_text(content, encoding='utf-8')
        
        # Update CCNUthesis.cls
        cls_file = release_dir / self.cls_file
        if cls_file.exists():
            content = cls_file.read_text(encoding='utf-8')
            # Update asset paths
            replacements = [
                ('../assets/images/figures/', 'figures/'),
                ('../assets/images/logos/', 'logo/'),
                ('../assets/documents/copyright/', 'copyright/'),
            ]
            for old, new in replacements:
                content = content.replace(old, new)
            cls_file.write_text(content, encoding='utf-8')
            
    def clean_auxiliary_files(self, directory: Path):
        """Clean LaTeX auxiliary files."""
        aux_extensions = [
            '.aux', '.bbl', '.bcf', '.blg', '.fdb_latexmk',
            '.fls', '.log', '.out', '.run.xml', '.synctex.gz',
            '.toc', '.xdv', '.ilg', '.ind', '.idx', '.glo'
        ]
        
        for ext in aux_extensions:
            for file in directory.glob(f"*{ext}"):
                file.unlink()
                
        # Clean subdirectories
        for subdir in directory.glob("*/"):
            if subdir.is_dir():
                for ext in aux_extensions:
                    for file in subdir.glob(f"*{ext}"):
                        file.unlink()
                        
    def create_archive(self, release_dir: Path, version: str) -> Path:
        """Create release archive."""
        archive_name = f"CCNUthesis-v{version}.zip"
        archive_path = self.release_dir / archive_name
        
        # Remove old archive if exists
        if archive_path.exists():
            archive_path.unlink()
            
        self.logger.info(f"Creating archive: {archive_name}")
        
        # Create zip archive
        with zipfile.ZipFile(archive_path, 'w', zipfile.ZIP_DEFLATED) as zipf:
            base_name = release_dir.name
            for root, dirs, files in os.walk(release_dir):
                # Skip hidden directories and __MACOSX
                dirs[:] = [d for d in dirs if not d.startswith('.') and d != '__MACOSX']
                
                for file in files:
                    # Skip hidden files and .DS_Store
                    if file.startswith('.') or file == '.DS_Store':
                        continue
                        
                    file_path = Path(root) / file
                    arcname = base_name / file_path.relative_to(release_dir)
                    zipf.write(file_path, arcname)
                    
        self.logger.info(f"✓ Archive created: {archive_path}")
        return archive_path
        
    def run(self, version: Optional[str] = None, skip_compile: bool = False,
            skip_docs: bool = False) -> bool:
        """Run the build process."""
        # Get version
        version = self.get_version_from_user(version)
        
        # Update version in files
        if not self.update_version(version):
            self.logger.error("Failed to update version")
            return False
            
        # Compile documentation
        if not skip_docs:
            if not self.build_documentation():
                self.logger.warning("Documentation compilation failed")
                
        # Compile example
        if not skip_compile:
            if not self.build_example():
                self.logger.warning("Example compilation failed")
                
        # Prepare release files
        release_dir = self.prepare_release_files(version)
        
        # Clean auxiliary files
        self.clean_auxiliary_files(release_dir)
        
        # Create archive
        archive_path = self.create_archive(release_dir, version)
        
        self.logger.info("=" * 50)
        self.logger.info(f"✓ Build completed successfully!")
        self.logger.info(f"  Version: v{version}")
        self.logger.info(f"  Release: {release_dir}")
        self.logger.info(f"  Archive: {archive_path}")
        self.logger.info("=" * 50)
        
        return True


def main():
    """Main entry point."""
    parser = argparse.ArgumentParser(
        description='Build and package CCNUthesis LaTeX template'
    )
    parser.add_argument(
        'version',
        nargs='?',
        help='Version number (e.g., 1.4.7)'
    )
    parser.add_argument(
        '--skip-compile',
        action='store_true',
        help='Skip LaTeX compilation'
    )
    parser.add_argument(
        '--skip-docs',
        action='store_true',
        help='Skip documentation building'
    )
    parser.add_argument(
        '--debug',
        action='store_true',
        help='Enable debug output'
    )
    
    args = parser.parse_args()
    
    # Create and run builder
    builder = CCNUthesisBuild(debug=args.debug)
    success = builder.run(
        version=args.version,
        skip_compile=args.skip_compile,
        skip_docs=args.skip_docs
    )
    
    sys.exit(0 if success else 1)


if __name__ == '__main__':
    main()