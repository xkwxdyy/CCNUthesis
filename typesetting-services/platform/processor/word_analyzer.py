#!/usr/bin/env python3

import os
import json
from typing import Dict, List, Any
from docx import Document
from docx.table import Table
from docx.text.paragraph import Paragraph
import re

class WordAnalyzer:
    """Analyze Word document structure for pricing calculation."""
    
    def __init__(self, file_path: str):
        self.file_path = file_path
        self.doc = Document(file_path)
        self.stats = {
            'page_count': 0,
            'word_count': 0,
            'formula_count': 0,
            'table_count': 0,
            'image_count': 0,
            'reference_count': 0,
            'heading_count': 0,
            'chapters': []
        }
    
    def analyze(self) -> Dict[str, Any]:
        """Perform comprehensive document analysis."""
        self._count_pages()
        self._count_words()
        self._count_tables()
        self._count_images()
        self._count_formulas()
        self._count_references()
        self._extract_structure()
        
        return self.stats
    
    def _count_pages(self):
        """Estimate page count based on word count."""
        # Rough estimation: ~300 words per page for Chinese documents
        total_words = sum(len(p.text) for p in self.doc.paragraphs)
        self.stats['page_count'] = max(1, total_words // 300)
    
    def _count_words(self):
        """Count total words in document."""
        total_words = 0
        for paragraph in self.doc.paragraphs:
            # Count Chinese characters and English words
            text = paragraph.text
            chinese_chars = len(re.findall(r'[\u4e00-\u9fff]', text))
            english_words = len(re.findall(r'\b[a-zA-Z]+\b', text))
            total_words += chinese_chars + english_words
        
        self.stats['word_count'] = total_words
    
    def _count_tables(self):
        """Count tables in document."""
        self.stats['table_count'] = len(self.doc.tables)
        
        # Analyze table complexity
        table_details = []
        for i, table in enumerate(self.doc.tables):
            rows = len(table.rows)
            cols = len(table.columns) if table.rows else 0
            cells = rows * cols
            
            table_details.append({
                'index': i + 1,
                'rows': rows,
                'columns': cols,
                'cells': cells,
                'complexity': 'complex' if cells > 50 else 'simple'
            })
        
        self.stats['table_details'] = table_details
    
    def _count_images(self):
        """Count embedded images in document."""
        # Count inline shapes (images)
        image_count = 0
        for paragraph in self.doc.paragraphs:
            for run in paragraph.runs:
                if run._element.xpath('.//w:drawing'):
                    image_count += 1
        
        self.stats['image_count'] = image_count
    
    def _count_formulas(self):
        """Detect and count mathematical formulas."""
        formula_count = 0
        formula_patterns = [
            r'\\[a-zA-Z]+\{',  # LaTeX commands
            r'\$.*?\$',  # Inline math
            r'∫|∑|∏|√|±|≠|≤|≥|∈|∉|⊂|⊃|∪|∩',  # Math symbols
            r'[a-zA-Z]\s*=\s*[^\s]',  # Equations
            r'\d+\s*[+\-*/]\s*\d+',  # Basic arithmetic
        ]
        
        for paragraph in self.doc.paragraphs:
            text = paragraph.text
            for pattern in formula_patterns:
                matches = re.findall(pattern, text)
                formula_count += len(matches)
        
        # Check for equation objects
        for paragraph in self.doc.paragraphs:
            if paragraph._element.xpath('.//m:oMath'):
                formula_count += 1
        
        self.stats['formula_count'] = formula_count
    
    def _count_references(self):
        """Count references/citations in document."""
        reference_count = 0
        
        # Look for reference section
        in_reference_section = False
        for paragraph in self.doc.paragraphs:
            text = paragraph.text.strip()
            
            # Check if we're in reference section
            if re.match(r'^(参考文献|References?|Bibliography)', text, re.IGNORECASE):
                in_reference_section = True
                continue
            
            if in_reference_section and text:
                # Count numbered references
                if re.match(r'^\[\d+\]', text) or re.match(r'^\d+\.', text):
                    reference_count += 1
        
        # Also count inline citations
        for paragraph in self.doc.paragraphs:
            citations = re.findall(r'\[\d+(?:[-,]\d+)*\]', paragraph.text)
            self.stats['inline_citations'] = len(citations)
        
        self.stats['reference_count'] = reference_count
    
    def _extract_structure(self):
        """Extract document structure (chapters, sections)."""
        chapters = []
        current_chapter = None
        
        for paragraph in self.doc.paragraphs:
            # Check if paragraph is a heading
            if paragraph.style.name.startswith('Heading'):
                level = int(paragraph.style.name[-1]) if paragraph.style.name[-1].isdigit() else 1
                
                chapter_info = {
                    'title': paragraph.text.strip(),
                    'level': level,
                    'sections': []
                }
                
                if level == 1:
                    if current_chapter:
                        chapters.append(current_chapter)
                    current_chapter = chapter_info
                elif current_chapter and level > 1:
                    current_chapter['sections'].append(chapter_info)
        
        if current_chapter:
            chapters.append(current_chapter)
        
        self.stats['chapters'] = chapters
        self.stats['heading_count'] = len(chapters)
    
    def calculate_price(self) -> Dict[str, Any]:
        """Calculate estimated price based on document analysis."""
        base_price = 200
        page_price = 5 * self.stats['page_count']
        formula_price = 3 * self.stats['formula_count']
        table_price = 10 * self.stats['table_count']
        ref_price = 2 * self.stats['reference_count']
        image_price = 5 * self.stats['image_count']
        
        # Calculate complexity factor
        total_elements = (
            self.stats['formula_count'] + 
            self.stats['table_count'] + 
            self.stats['image_count']
        )
        
        complexity_factor = 1.0
        if total_elements > 50:
            complexity_factor = 1.2
        elif total_elements > 100:
            complexity_factor = 1.5
        
        subtotal = base_price + page_price + formula_price + table_price + ref_price + image_price
        total_price = round(subtotal * complexity_factor)
        
        return {
            'base_price': base_price,
            'page_price': page_price,
            'formula_price': formula_price,
            'table_price': table_price,
            'reference_price': ref_price,
            'image_price': image_price,
            'complexity_factor': complexity_factor,
            'subtotal': subtotal,
            'total_price': total_price,
            'breakdown': {
                'pages': f"{self.stats['page_count']} × ¥5",
                'formulas': f"{self.stats['formula_count']} × ¥3",
                'tables': f"{self.stats['table_count']} × ¥10",
                'references': f"{self.stats['reference_count']} × ¥2",
                'images': f"{self.stats['image_count']} × ¥5",
            }
        }


def main():
    """CLI interface for testing."""
    import sys
    
    if len(sys.argv) < 2:
        print("Usage: python word_analyzer.py <word_file>")
        sys.exit(1)
    
    file_path = sys.argv[1]
    
    if not os.path.exists(file_path):
        print(f"Error: File {file_path} not found")
        sys.exit(1)
    
    try:
        analyzer = WordAnalyzer(file_path)
        stats = analyzer.analyze()
        price = analyzer.calculate_price()
        
        result = {
            'file': os.path.basename(file_path),
            'statistics': stats,
            'pricing': price
        }
        
        print(json.dumps(result, ensure_ascii=False, indent=2))
        
    except Exception as e:
        print(f"Error analyzing document: {str(e)}")
        sys.exit(1)


if __name__ == "__main__":
    main()