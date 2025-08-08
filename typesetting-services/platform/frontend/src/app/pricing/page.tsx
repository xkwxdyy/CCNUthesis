'use client';

import { useState } from 'react';
import { Card, Form, InputNumber, Button, Upload, Typography, Space, Alert, Divider, Tag, Result } from 'antd';
import { UploadOutlined, CalculatorOutlined } from '@ant-design/icons';
import MainLayout from '@/components/layout/MainLayout';
import type { UploadFile } from 'antd';

const { Title, Paragraph, Text } = Typography;

interface PriceCalculation {
  basePrice: number;
  pagePrice: number;
  formulaPrice: number;
  tablePrice: number;
  refPrice: number;
  complexityFactor: number;
  totalPrice: number;
}

export default function PricingPage() {
  const [form] = Form.useForm();
  const [fileList, setFileList] = useState<UploadFile[]>([]);
  const [calculation, setCalculation] = useState<PriceCalculation | null>(null);
  const [isAnalyzing, setIsAnalyzing] = useState(false);

  const calculatePrice = (values: any) => {
    const basePrice = 200;
    const pagePrice = 5 * (values.pageCount || 0);
    const formulaPrice = 3 * (values.formulaCount || 0);
    const tablePrice = 10 * (values.tableCount || 0);
    const refPrice = 2 * (values.refCount || 0);
    
    // Complexity factor based on total elements
    const totalElements = (values.formulaCount || 0) + (values.tableCount || 0);
    let complexityFactor = 1;
    if (totalElements > 50) complexityFactor = 1.2;
    if (totalElements > 100) complexityFactor = 1.5;
    
    const totalPrice = Math.round(
      (basePrice + pagePrice + formulaPrice + tablePrice + refPrice) * complexityFactor
    );

    setCalculation({
      basePrice,
      pagePrice,
      formulaPrice,
      tablePrice,
      refPrice,
      complexityFactor,
      totalPrice,
    });
  };

  const handleFileUpload = async (file: any) => {
    setIsAnalyzing(true);
    
    // Simulate file analysis
    setTimeout(() => {
      // Mock analysis results
      form.setFieldsValue({
        pageCount: Math.floor(Math.random() * 50) + 20,
        formulaCount: Math.floor(Math.random() * 30) + 5,
        tableCount: Math.floor(Math.random() * 15) + 3,
        refCount: Math.floor(Math.random() * 40) + 10,
      });
      
      form.submit();
      setIsAnalyzing(false);
    }, 2000);

    return false;
  };

  return (
    <MainLayout>
      <div style={{ maxWidth: 1200, margin: '0 auto' }}>
        <Title level={2} style={{ textAlign: 'center', marginBottom: 40 }}>
          价格计算器
        </Title>

        <Alert
          message="智能定价说明"
          description="上传您的 Word 文档，系统将自动分析文档结构并计算价格。您也可以手动输入各项数量进行估算。"
          type="info"
          showIcon
          style={{ marginBottom: 24 }}
        />

        <Card>
          <Upload.Dragger
            fileList={fileList}
            beforeUpload={handleFileUpload}
            onRemove={() => setFileList([])}
            onChange={({ fileList }) => setFileList(fileList)}
            maxCount={1}
            accept=".doc,.docx"
          >
            <p className="ant-upload-drag-icon">
              <UploadOutlined style={{ fontSize: 48 }} />
            </p>
            <p className="ant-upload-text">点击或拖拽文件到此处上传</p>
            <p className="ant-upload-hint">
              支持 .doc, .docx 格式，文件将被自动分析
            </p>
          </Upload.Dragger>

          <Divider>或手动输入</Divider>

          <Form
            form={form}
            layout="vertical"
            onFinish={calculatePrice}
            initialValues={{
              pageCount: 0,
              formulaCount: 0,
              tableCount: 0,
              refCount: 0,
            }}
          >
            <Space size="large" wrap style={{ width: '100%' }}>
              <Form.Item label="页数" name="pageCount">
                <InputNumber min={0} placeholder="论文页数" style={{ width: 150 }} />
              </Form.Item>
              <Form.Item label="公式数量" name="formulaCount">
                <InputNumber min={0} placeholder="公式数量" style={{ width: 150 }} />
              </Form.Item>
              <Form.Item label="表格数量" name="tableCount">
                <InputNumber min={0} placeholder="表格数量" style={{ width: 150 }} />
              </Form.Item>
              <Form.Item label="参考文献数" name="refCount">
                <InputNumber min={0} placeholder="参考文献数" style={{ width: 150 }} />
              </Form.Item>
            </Space>

            <Form.Item style={{ marginTop: 24 }}>
              <Button 
                type="primary" 
                htmlType="submit" 
                icon={<CalculatorOutlined />}
                loading={isAnalyzing}
                size="large"
              >
                {isAnalyzing ? '分析中...' : '计算价格'}
              </Button>
            </Form.Item>
          </Form>
        </Card>

        {calculation && (
          <Card style={{ marginTop: 24 }}>
            <Result
              status="success"
              title={`预估价格：¥${calculation.totalPrice}`}
              subTitle="价格明细如下"
              extra={[
                <Button type="primary" key="order">
                  立即下单
                </Button>,
                <Button key="contact">联系客服</Button>,
              ]}
            >
              <div style={{ background: '#f5f5f5', padding: 16, borderRadius: 8 }}>
                <Space direction="vertical" style={{ width: '100%' }}>
                  <div style={{ display: 'flex', justifyContent: 'space-between' }}>
                    <Text>基础费用</Text>
                    <Text strong>¥{calculation.basePrice}</Text>
                  </div>
                  <div style={{ display: 'flex', justifyContent: 'space-between' }}>
                    <Text>页数费用</Text>
                    <Text>¥{calculation.pagePrice}</Text>
                  </div>
                  <div style={{ display: 'flex', justifyContent: 'space-between' }}>
                    <Text>公式处理</Text>
                    <Text>¥{calculation.formulaPrice}</Text>
                  </div>
                  <div style={{ display: 'flex', justifyContent: 'space-between' }}>
                    <Text>表格处理</Text>
                    <Text>¥{calculation.tablePrice}</Text>
                  </div>
                  <div style={{ display: 'flex', justifyContent: 'space-between' }}>
                    <Text>参考文献</Text>
                    <Text>¥{calculation.refPrice}</Text>
                  </div>
                  {calculation.complexityFactor > 1 && (
                    <div style={{ display: 'flex', justifyContent: 'space-between' }}>
                      <Text>复杂度系数</Text>
                      <Tag color="orange">×{calculation.complexityFactor}</Tag>
                    </div>
                  )}
                  <Divider style={{ margin: '12px 0' }} />
                  <div style={{ display: 'flex', justifyContent: 'space-between' }}>
                    <Text strong style={{ fontSize: 16 }}>总计</Text>
                    <Text strong style={{ fontSize: 16, color: '#1890ff' }}>
                      ¥{calculation.totalPrice}
                    </Text>
                  </div>
                </Space>
              </div>
            </Result>
          </Card>
        )}

        <Card style={{ marginTop: 24 }}>
          <Title level={4}>定价说明</Title>
          <Paragraph>
            <ul>
              <li>基础费用：¥200（包含基本排版服务）</li>
              <li>页数：¥5/页</li>
              <li>公式：¥3/个</li>
              <li>表格：¥10/个</li>
              <li>参考文献：¥2/条</li>
              <li>复杂度系数：根据文档复杂程度自动调整（1.0-1.5）</li>
            </ul>
          </Paragraph>
          <Alert
            message="推广优惠"
            description="邀请好友成功下单，您和好友都可获得 ¥30 优惠！"
            type="success"
            showIcon
          />
        </Card>
      </div>
    </MainLayout>
  );
}