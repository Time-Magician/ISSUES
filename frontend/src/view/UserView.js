import React from 'react';
import {Button, Form, Layout} from 'antd'
import {HeaderInfo} from "../components/HeaderInfo";
import {SideBar} from "../components/SideBar4";
import '../css/home.css'
import {withRouter} from "react-router-dom";
import 'antd/dist/antd.css';
import { Table} from 'antd';
import {antiforbidden,forbidden, getUser,ifadmin} from "../services/userService";
import { DatePicker } from 'antd';

const { RangePicker } = DatePicker;
const { Header, Content, Footer } = Layout;

const columns = [
    {
        title: 'userId',
        dataIndex: 'userId',
        key: 'userId',
    },
    {
        title: 'name',
        dataIndex: 'name',
        key: 'name',
    },
    {
        title: 'role',
        dataIndex: 'role',
        key: 'role',
    },
    {
        title: 'forbidden',
        dataIndex: 'forbidden',
        key: 'forbidden',
    },
];

class UserView extends React.Component{

    constructor(props) {
        super(props);

        this.state = {users:null};
    }

    componentDidMount(){
        let user = localStorage.getItem("user");
        this.setState({user:user});

        let user2 = JSON.parse(user);
        let username = user2['username'];
        getUser((data) => {this.setState({users: data})})
    }
    state = {
        selectedRowKeys: [],
    };
    selectRow = (record) => {
        const selectedRowKeys = [...this.state.selectedRowKeys];
        if (selectedRowKeys.indexOf(record.key) >= 0) {
            selectedRowKeys.splice(selectedRowKeys.indexOf(record.key), 1);
        } else {
            selectedRowKeys.push(record.key);
        }
        this.setState({ selectedRowKeys });
    }
    onSelectedRowKeysChange = (selectedRowKeys) => {
        this.setState({ selectedRowKeys });
    }
    jin = () =>{
        for (var num = 0;num < (this.state.selectedRowKeys).length;num++){
            forbidden(this.state.selectedRowKeys[num]+1);
        };
    }
    jie = () =>{
        for (var num = 0;num < (this.state.selectedRowKeys).length;num++){
            antiforbidden(this.state.selectedRowKeys[num]+1);
        };
    }
    render(){
        const { selectedRowKeys } = this.state;
        const rowSelection = {
            selectedRowKeys,
            onChange: this.onSelectedRowKeysChange,
        };

        return(
            <Layout className="layout">

                <Header>
                    <HeaderInfo />
                </Header>
                <Layout>
                    <SideBar />
                    <Content style={{ padding: '0 50px' }}>
                        <Form onSubmit={this.handleSubmit} className="login-form">
                            <Form.Item label="选择日期">
                                <RangePicker onChange={this.onChange} format="YYYY-MM-DD" placeholder="选择日期" />
                            </Form.Item>
                            <Button type="primary" href="/select" className="login-form-button">
                                查询
                            </Button>
                        </Form>
                                             <Table
                                                rowSelection={rowSelection}
                                                columns={columns}
                                                dataSource={this.state.users}
                                                onRow={(record) => ({
                                                    onClick: () => {
                                                        this.selectRow(record);
                                                    },
                                                })}
                                            />
                        <Button type="danger" size={"large"} onClick={this.jin}>
                            禁用
                        </Button>
                        <Button type="danger" size={"large"} onClick={this.jie}>
                            解禁
                        </Button>
                    </Content>
                </Layout>
            </Layout>

        );
    }
}

export default withRouter(UserView);
