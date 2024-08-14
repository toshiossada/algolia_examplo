# Configurar projeto

Para fazer a configuração do projeto é necessario criar o arquivo `.env` na raiz do projeto com os valores:

```.env
APPPLICATION_ID=
API_KEY=
INDEX_NAME=
```

Após criar e configurar o `.env` é necessario executar o build_runner

```sh
dart pub run build_runner build
```

Se o arquivo .env for alterado e não surtir efeito é necessario executar

```sh
dart run build_runner clean
dart pub run build_runner build -d
```
