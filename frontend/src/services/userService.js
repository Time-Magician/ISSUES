import config from 'config';
import {postRequest, postRequest_v2} from "../utils/ajax";
import {history} from '../utils/history';
import {message} from 'antd';
import axios from "axios"

export const login = (data) => {
    const url = "http://localhost:9000/user-service/login?credentials="+data.username+"&client_id=issuesApp&client_secret=sjtu&password="+data.password+"&grant_type=password";
    console.log(url);

    var axios = require('axios');

    var config = {
        method: 'get',
        url: url,
        headers: { }
    };

    axios(config)
        .then(function (response) {
            console.log(JSON.stringify(response.data.data));
            if(response.data.status >= 0) {
                localStorage.setItem('user', JSON.stringify(response.data.data));
                history.push("/");
                message.success(response.data.msg);
            }
            else{
                message.error(response.data.msg);
            }
        })
        .catch(function (error) {
            console.log(error);
        });

};

