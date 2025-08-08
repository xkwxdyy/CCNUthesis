'use client';

import { Layout, Menu, Button, Space } from 'antd';
import { UserOutlined, FileTextOutlined, CalculatorOutlined, TeamOutlined } from '@ant-design/icons';
import Link from 'next/link';
import { usePathname } from 'next/navigation';

const { Header } = Layout;

export default function AppHeader() {
  const pathname = usePathname();

  const menuItems = [
    {
      key: '/',
      icon: <FileTextOutlined />,
      label: <Link href="/">首页</Link>,
    },
    {
      key: '/pricing',
      icon: <CalculatorOutlined />,
      label: <Link href="/pricing">价格计算</Link>,
    },
    {
      key: '/services',
      icon: <FileTextOutlined />,
      label: <Link href="/services">服务介绍</Link>,
    },
    {
      key: '/portfolio',
      icon: <TeamOutlined />,
      label: <Link href="/portfolio">案例展示</Link>,
    },
  ];

  return (
    <Header style={{ background: '#fff', borderBottom: '1px solid #f0f0f0', padding: '0 50px' }}>
      <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center' }}>
        <div style={{ display: 'flex', alignItems: 'center' }}>
          <h2 style={{ margin: '0 30px 0 0' }}>CCNUthesis 代排平台</h2>
          <Menu
            mode="horizontal"
            selectedKeys={[pathname]}
            items={menuItems}
            style={{ border: 'none', minWidth: 400 }}
          />
        </div>
        <Space>
          <Button type="primary" icon={<UserOutlined />}>
            <Link href="/login">登录</Link>
          </Button>
          <Button>
            <Link href="/register">注册</Link>
          </Button>
        </Space>
      </div>
    </Header>
  );
}