# EKS叢集連接和Nginx部署指南

本指南說明如何連接到已部署的EKS叢集，並部署Nginx示例應用。

## 連接到EKS叢集

### 步驟1：獲取叢集信息

在部署叢集的目錄中運行以下命令，獲取叢集名稱和區域：

```bash
cd learn-terraform-provision-eks-cluster
terraform output cluster_name
terraform output region
```

### 步驟2：更新kubectl配置

使用AWS CLI更新kubectl配置，以連接到您的EKS叢集：

```bash
aws eks update-kubeconfig --name $(terraform output -raw cluster_name) --region $(terraform output -raw region)
```

### 步驟3：驗證連接

運行以下命令，確認您可以成功連接到叢集：

```bash
kubectl get nodes
```

這應該會顯示您的EKS叢集中的節點列表。

## 部署Nginx

### 步驟1：應用Nginx部署文件

使用以下命令部署Nginx：

```bash
kubectl apply -f nginx-deployment.yaml
```

### 步驟2：檢查部署狀態

檢查部署是否成功：

```bash
kubectl get deployments
```

檢查Pod是否正在運行：

```bash
kubectl get pods
```

### 步驟3：獲取服務信息

檢查服務狀態並獲取外部IP/域名：

```bash
kubectl get services
```

在輸出中，您應該能看到`nginx`服務的`EXTERNAL-IP`列。這是AWS為您的服務創建的負載均衡器的地址。可能需要幾分鐘才能從`<pending>`變為實際的地址。

### 步驟4：訪問Nginx

一旦您有了外部IP或域名，您可以通過瀏覽器訪問它，或使用curl：

```bash
curl http://<EXTERNAL-IP>
```

您應該會看到Nginx的歡迎頁面。

## 設置域名（可選）

如果您有自己的域名，可以在Route 53中創建一個記錄，指向負載均衡器的地址：

1. 在AWS控制台中打開Route 53
2. 選擇您的託管區域
3. 創建一個記錄
4. 選擇記錄類型為A或CNAME
5. 對於值/路由到，選擇別名到應用和網絡負載均衡器，然後選擇您的負載均衡器

## 清理資源

當您不再需要這些資源時，可以刪除它們：

```bash
# 刪除Nginx部署和服務
kubectl delete -f nginx-deployment.yaml

# 刪除EKS叢集和相關資源
cd learn-terraform-provision-eks-cluster
terraform destroy
```

當系統提示確認時，輸入"yes"。
