# STUDY 模块

## createFrog

![createFrog](D:\Desktop\白盒测试-Study\createFrog.png)
$$
V(G)=12-10+2=4\\
\begin{align*}
Basis\ Path:&\\
&(1)A-B-C-E-G-I-J\\
&(2)A-B-C-D-J\\
&(3)A-B-C-E-F-J\\
&(4)A-B-C-E-G-H-J
\end{align*}
$$

| Test Case | userId(pathVariable) | userId(httpRequest Header) | level | exp  | graduate_date | Expected Result                                       | 对应的Basis Path |
| --------- | -------------------- | -------------------------- | ----- | ---- | ------------- | ----------------------------------------------------- | ---------------- |
| 1         | 1                    | 1                          | 10    | 10   | “2020-1-1”    | 成功,返回mockFrog                                     | (1)              |
| 2         | 1                    | 2                          | 10    | 10   | “2020-1-1”    | Error:Permission Denied!                              | (2)              |
| 3         | 1                    | 1                          | 100   | 10   | “2020-1-1”    | NULL*(level不在取值范围内,0≤level≤17)*                | (3)              |
| 4         | 1                    | 1                          | -20   | 10   | “2020-1-1”    | NULL*(level不在取值范围内,0≤level≤17)*                | (3)              |
| 5         | 1                    | 1                          | 10    | -100 | “2020-1-1”    | NULL*(exp不在取值范围内,0≤exp≤100)*                   | (3)              |
| 6         | 1                    | 1                          | 10    | 200  | “2020-1-1”    | NULL*(exp不在取值范围内,0≤exp≤100)*                   | (3)              |
| 7         | 1                    | 1                          | 10    | 10   | “2020-13-51”  | NULL*(graduate_date不在取值范围内，它不是合法的日期)* | (4)              |



## updateFrog

![updateFrog](D:\Desktop\白盒测试-Study\updateFrog.png)
$$
V(G)=12-10+2=4\\
\begin{align*}
Basis\ Path:&\\
&(1)A-B-C-E-G-I-J\\
&(2)A-B-C-D-J\\
&(3)A-B-C-E-F-J\\
&(4)A-B-C-E-G-H-J
\end{align*}
$$
*TestCase 同 createFrog*

## getFrogByUser

![getFrogByUser](D:\Desktop\白盒测试-Study\getFrogByUser.png)


$$
V(G)=6-6+2=2\\
\begin{align*}
Basis\ Path:&\\
&(1)A-B-C-E-F\\
&(2)A-B-C-D-F\\
\end{align*}
$$

| Test Case | userId(pathVariable) | userId(httpRequest Header) | Expected Result              | 对应 Basis Path |
| --------- | -------------------- | -------------------------- | ---------------------------- | --------------- |
| 1         | 1                    | 1                          | 成功,返回mockFrog            | (1)             |
| 2         | 1                    | 2                          | NULL*（Permission Denied!）* | (2)             |

## createAlarmRecord

![createAlarmRecord](D:\Desktop\白盒测试-Study\createAlarmRecord.png)
$$
V(G)=12-10+2=4\\
\begin{align*}
Basis\ Path:&\\
&(1)A-B-C-E-G-I-J\\
&(2)A-B-C-D-J\\
&(3)A-B-C-E-F-J\\
&(4)A-B-C-E-G-H-J
\end{align*}
$$

| Test Case | userId(pathVariable) | userId(httpRequest Header) | alarm_id | frog_id | duration | mission       |                      Expected Result                       | 对应 Basis Path |
| --------- | -------------------- | -------------------------- | -------- | ------- | -------- | ------------- | :--------------------------------------------------------: | --------------- |
| 1         | 1                    | 1                          | 23       | 1       | 120      | “随机任务”    |                 成功，返回mockAlarmRecord                  | (1)             |
| 2         | 1                    | 2                          | 23       | 1       | 120      | “随机任务”    |                NULL*（Permission Denied!）*                | (2)             |
| 3         | 1                    | 1                          | -23      | 1       | 120      | “随机任务”    | NULL*（alarm_id不在取值范围内，它应该满足：alarm_id ≥ 0）* | (4)             |
| 4         | 1                    | 1                          | 23       | -10     | 120      | “随机任务”    |  NULL*（frog_id不在取值范围内，它应该满足：frog_id ≥ 0）*  | (4)             |
| 5         | 1                    | 1                          | 23       | 1       | -100     | “随机任务”    | NULL*（duration不在取值范围内，它应该满足：duration ≥ 0）* | (4)             |
| 6         | 1                    | 1                          | 23       | 1       | 120      | “TestMission” |               NULL*(mission不在取值范围内)*                | (3)             |

## createStudyRecord

![createStudyRecord](D:\Desktop\白盒测试-Study\createStudyRecord.png)
$$
V(G)=15-12+2=5\\
\begin{align*}
Basis\ Path:&\\
&(1)A-B-C-E-G-I-K-L\\
&(2)A-B-C-D-L\\
&(3)A-B-C-E-F-L\\
&(4)A-B-C-E-G-H-L\\
&(5)A-B-C-E-G-I-J-L
\end{align*}
$$

| Test Case | userId(pathVariable) | userId(httpRequest Header) | start_time   | end_time     | frog_id | duration | Expected Result                                            | 对应 Basis Path |
| --------- | -------------------- | -------------------------- | ------------ | ------------ | ------- | -------- | ---------------------------------------------------------- | --------------- |
| 1         | 1                    | 1                          | “2021-4-10”  | “2021-4-10”  | 1       | 120      | 成功，返回mockStudyRecord                                  | (1)             |
| 2         | 1                    | 2                          | “2021-4-10”  | “2021-4-10”  | 1       | 120      | NULL*（Permission Denied!）*                               | (2)             |
| 3         | 1                    | 1                          | “2021-4-11”  | “2021-4-10”  | 1       | 120      | NULL*（start_time > end_time,为无效值）*                   | (4)             |
| 4         | 1                    | 1                          | “2021-13-21” | “2021-4-10”  | 1       | 120      | NULL*（start_time无法解析，为无效值）*                     | (3)             |
| 5         | 1                    | 1                          | “2021-4-10”  | “2021-13-21” | 1       | 120      | NULL*（end_time无法解析，为无效值）*                       | (3)             |
| 6         | 1                    | 1                          | “2021-4-10”  | “2021-4-10”  | -20     | 120      | NULL*（frog_id不在取值范围内，它应该满足：frog_id ≥ 0）*   | (5)             |
| 7         | 1                    | 1                          | “2021-4-10”  | “2021-4-10”  | 1       | -100     | NULL*（duration不在取值范围内，它应该满足：duration ≥ 0）* | (5)             |