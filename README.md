# nginx-rp-lb
Documented implementation of nginx as reverse proxy for frontend server and as load balancer for backend servers

## Infrastructure diagram
![infrastructure diagram](https://github.com/aryyawijaya/nginx-rp-lb/blob/main/infra-diagram.png)

## IP mapping
| IP Address | Role |
|------------|------|
| 192.168.1.1  | Gateway |
| 192.168.1.6/24  | Load Balancer |
| 192.168.1.7/24  | Backend Server 1 |
| 192.168.1.8/24  | Backend Server 2 |
| 192.168.1.9/24  | Frontend Server |
| 192.168.1.10/24  | Reverse Proxy |

## Build the infrastructure
### Create load balancer
```bash
startup-lb-server.sh 192.168.1.6/24 192.168.1.1
```

### Create backend server 1 & 2
```bash
startup-backend-server.sh 192.168.1.7/24 192.168.1.1
```
```bash
startup-backend-server.sh 192.168.1.8/24 192.168.1.1
```

### Create frontend server
```bash
startup-frontend-server.sh 192.168.1.9/24 192.168.1.1
```

### Create reverse proxy
```bash
startup-rp-server.sh 192.168.1.10/24 192.168.1.1
```

## Demo
![demo-1](https://github.com/aryyawijaya/nginx-rp-lb/blob/main/demo-1.png)

![demo-2](https://github.com/aryyawijaya/nginx-rp-lb/blob/main/demo-2.png)

![demo-3](https://github.com/aryyawijaya/nginx-rp-lb/blob/main/demo-3.png)
