#  Clean Architecture
- 参照: iOSアプリ開発デザインパターン入門
## 用語
- Entity: アプリケーションに依存しない、ドメインに関するデータ構造やビジネスロジック
- Use Case: アプリケーションで固有なロジック
- Interface Adapter: Use Case, Framework, Driverで使われるデータ構造を互いに変換する
- Framework & Driver: DB, Webなどのフレームワークやツールの詳細


# VIPER
## 用語
- View: 画面表示とUIイベント受信。UIView(UIViewController)。CleanArchitectureのFramework & Driver
- Interactor: データ操作とユースケース。Entityを使ってビジネスロジックを表現する。CleanArchitectureのUse Case
- Presenter: アーキテクチャ上のメディエータ（Mediator）。UIKit非依存。CleanArchitectureのInterface Adapter
- Entity: Interactorによってのみ使われる単純な構造のモデル。CleanArchitectureのEntity
- Router: 画面遷移と新しい画面のセットアップ


