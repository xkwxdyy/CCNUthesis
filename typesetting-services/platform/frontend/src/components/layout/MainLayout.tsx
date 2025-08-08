'use client';

import { Layout } from 'antd';
import AppHeader from './Header';

const { Content, Footer } = Layout;

export default function MainLayout({ children }: { children: React.ReactNode }) {
  return (
    <Layout style={{ minHeight: '100vh' }}>
      <AppHeader />
      <Content style={{ padding: '24px 50px', background: '#f5f5f5' }}>
        {children}
      </Content>
      <Footer style={{ textAlign: 'center', background: '#fff' }}>
        <div>
          <p>CCNUthesis 代排服务 ©2021-{new Date().getFullYear()}</p>
          <p>
            联系方式：QQ: 617315571 | 微信: xiakangwei001
          </p>
        </div>
      </Footer>
    </Layout>
  );
}