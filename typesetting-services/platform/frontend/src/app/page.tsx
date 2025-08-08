'use client';

import { Button, Card, Row, Col, Typography, Space, Statistic, Upload, message } from 'antd';
import { CloudUploadOutlined, FileTextOutlined, CheckCircleOutlined, TeamOutlined } from '@ant-design/icons';
import MainLayout from '@/components/layout/MainLayout';
import Link from 'next/link';
import { useRouter } from 'next/navigation';

const { Title, Paragraph, Text } = Typography;

export default function Home() {
  const router = useRouter();

  const features = [
    {
      icon: <CloudUploadOutlined style={{ fontSize: 48, color: '#1890ff' }} />,
      title: '上传文档',
      description: '支持 Word 文档上传，自动分析内容结构',
    },
    {
      icon: <FileTextOutlined style={{ fontSize: 48, color: '#52c41a' }} />,
      title: '智能转换',
      description: '自动将 Word 转换为专业的 LaTeX 格式',
    },
    {
      icon: <CheckCircleOutlined style={{ fontSize: 48, color: '#722ed1' }} />,
      title: '质量保证',
      description: '专业排版，符合学校规范要求',
    },
    {
      icon: <TeamOutlined style={{ fontSize: 48, color: '#fa8c16' }} />,
      title: '推广返利',
      description: '邀请好友成功下单，立减30元',
    },
  ];

  const handleQuickUpload = () => {
    router.push('/pricing');
  };

  return (
    <MainLayout>
      <div style={{ maxWidth: 1200, margin: '0 auto' }}>
        {/* Hero Section */}
        <div style={{ textAlign: 'center', padding: '60px 0' }}>
          <Title level={1}>CCNUthesis 专业论文排版服务</Title>
          <Paragraph style={{ fontSize: 18, marginBottom: 40 }}>
            让 LaTeX 排版变得简单，你只需专注于内容创作
          </Paragraph>
          <Space size="large">
            <Button type="primary" size="large" onClick={handleQuickUpload}>
              立即上传文档
            </Button>
            <Button size="large">
              <Link href="/services">了解服务详情</Link>
            </Button>
          </Space>
        </div>

        {/* Statistics */}
        <Card style={{ marginBottom: 40 }}>
          <Row gutter={16}>
            <Col span={6}>
              <Statistic title="累计服务" value={150} suffix="位" />
            </Col>
            <Col span={6}>
              <Statistic title="平均完成时间" value={3} suffix="天" />
            </Col>
            <Col span={6}>
              <Statistic title="客户满意度" value={98} suffix="%" />
            </Col>
            <Col span={6}>
              <Statistic title="价格区间" value="200-500" prefix="¥" />
            </Col>
          </Row>
        </Card>

        {/* Features */}
        <Title level={2} style={{ textAlign: 'center', marginBottom: 40 }}>
          服务流程
        </Title>
        <Row gutter={[16, 16]}>
          {features.map((feature, index) => (
            <Col xs={24} sm={12} md={6} key={index}>
              <Card hoverable style={{ textAlign: 'center', height: '100%' }}>
                {feature.icon}
                <Title level={4} style={{ marginTop: 16 }}>
                  {feature.title}
                </Title>
                <Paragraph>{feature.description}</Paragraph>
              </Card>
            </Col>
          ))}
        </Row>

        {/* Quick Upload Section */}
        <Card style={{ marginTop: 60, textAlign: 'center' }}>
          <Title level={3}>快速开始</Title>
          <Paragraph>
            上传您的 Word 文档，立即获取报价
          </Paragraph>
          <Upload.Dragger
            maxCount={1}
            accept=".doc,.docx"
            beforeUpload={(file) => {
              message.info(`已选择文件: ${file.name}`);
              router.push('/pricing');
              return false;
            }}
            style={{ maxWidth: 600, margin: '0 auto' }}
          >
            <p className="ant-upload-drag-icon">
              <CloudUploadOutlined style={{ fontSize: 48 }} />
            </p>
            <p className="ant-upload-text">点击或拖拽文件到此区域上传</p>
            <p className="ant-upload-hint">
              支持 .doc, .docx 格式的 Word 文档
            </p>
          </Upload.Dragger>
        </Card>

        {/* CTA Section */}
        <div style={{ textAlign: 'center', padding: '60px 0' }}>
          <Title level={3}>还有疑问？</Title>
          <Space size="large">
            <Text>QQ: 617315571</Text>
            <Text>微信: xiakangwei001</Text>
          </Space>
          <div style={{ marginTop: 20 }}>
            <Button type="primary" size="large">
              <Link href="/services">查看详细服务说明</Link>
            </Button>
          </div>
        </div>
      </div>
    </MainLayout>
  );
}