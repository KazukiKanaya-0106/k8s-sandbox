# k8s-sandbox

ローカルで [kind](https://kind.sigs.k8s.io/) クラスタを作成し、FastAPI アプリケーションをデプロイする Kubernetes 練習用プロジェクトです。  
Deployment / Service / Ingress / HPA / ConfigMap / Secret などの基本リソースをひととおり触りながら、ローカル環境だけで Kubernetes を体験できます。

## 前提環境

- Docker（アプリケーションイメージのビルドに使用）
- [kind](https://kind.sigs.k8s.io/) と `kubectl`
- `make`

## アプリケーション概要

- `app/main.py` は `/`・`/health`・`/value` の 3 つのエンドポイントを提供します。
- `STAGE` は `k8s/configmap.yaml` で配布されます。
- `SECRET_VALUE` は `app/.env` を元に `k8s/secret.sh` で作成する Secret から読み込みます。
- コンテナはポート 80 で待ち受け、`k8s/kindconfig.yaml` でクラスタ Ingress を `localhost:8081` に割り当てています。

## セットアップと使い方

```bash
# 1. Secret 用の環境変数を準備
cp app/.env.example app/.env
# SECRET_VALUE など必要な値を編集

# 2. Docker イメージをビルド
make build

# 3. kind クラスタを作成
make create

# 4. ローカルイメージを kind に取り込み
make load

# 5. Kubernetes マニフェストを適用（Secret / ConfigMap / Deployment / Service / HPA / Ingress）
make apply
```

Ingress を適用すると、以下のエンドポイントでアプリにアクセスできます。

- `http://localhost:8081/` – サンプルレスポンス
- `http://localhost:8081/health` – Readiness / Liveness 用エンドポイント
- `http://localhost:8081/value` – ConfigMap と Secret の値を確認

## よく使うコマンド

```bash
make logs     # app=k8s-sandbox の Pod ログを確認
make restart  # Deployment をロールアウト再起動
make delete   # kind クラスタを削除
```

`kubectl get all` でリソースの状態を確認したり、`k8s/` 以下のマニフェストを読みながら各リソースのつながりを把握したりできます。

## クリーンアップ

作業が終わったら、以下でローカルクラスタとリソースをまとめて削除します。

```bash
make delete
```

これにより kind クラスタと関連するコンテナ・ネットワークがクリーンに整理されます。
