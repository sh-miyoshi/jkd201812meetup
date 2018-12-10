# 手順書

※作業中

## 環境

- gitlab.com
- GKE

## 手順

gitlab.comにアクセス
各Projectの作成
ruunnerを登録したいProject -> Setting -> CICD -> Runners(Expandをクリック)
Shared Runnerの無効化、Kubernetes Clusterの追加
GKEでClusterを追加(個数1 & n1-standard-1で問題なし、ただしOpsはn1-standard-2以上)
Helm、GitLab Runnerをインストール
各Clusterに乗り込んで以下の操作を行う
・ProjFrontend
  kubectl create ns projfrontend

・ProjBackend
  kubectl create ns projbackend

・ProjOps
  kubectl create ns staging
  kubectl create ns production
  kubectl apply -f gke-install-istio.yaml
各クラスタにアクセスするためのconfig情報を取得(TODO)
configファイルを/path/to/jkd201812meetup/各プロジェクト/configに置く
gitでソースをプッシュ
  git init
  git add -A
  git commit -m "first commit"
  git add origin <gitlab-url>
  git push origin master
