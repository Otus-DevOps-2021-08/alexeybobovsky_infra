# Практические работы по курсу **DevOps практики и инструменты** (alexeybobovsky_infra)
## Содержание

2. [Настройка локального окружения и практика ChatOps.](#lab_ChatOps) 
3. [Запуск VM в Yandex Cloud, настройка SSH подключения, настройка SSH подключения через Bastion Host, настройка VPN сервера и VPN-подключения.](#lab_bastion)
4. [Деплой тестового приложения в Yandex Cloud.](#cloud-testapp)

## Настройка локального окружения и практика ChatOps<a name="lab_ChatOps"></a>

### План работы
* Закрепляем знания по Git, работаем в своих репозиториях, созданных
после выполнения ДЗ№1
* Создаем интеграцию с чатом для вашего репозитория и подключение
Github Actions
### Практические задачи
Описание отсутствует
## Запуск VM в Yandex Cloud, настройка SSH подключения, настройка SSH подключения через Bastion Host, настройка VPN сервера и VPN-подключения.<a name="lab_bastion"></a>
### План работы 
* Создание учетной записи в Yandex.Cloud
* Создание в веб-интерфейсе инстансов ВМ и подключение к ним по SSH
* Организация подключений к хостам через бастион-хост и VPN
### Практические задачи  

Конфигурация тестового стенда:
```
bastion_IP = 62.84.118.41 
someinternalhost_IP = 10.128.0.27
```

#### Создание *прямого* ssh подключения к хосту в облаке без внешнего IP адреса (самостоятельное задание)   
Для организации требуемого подключения используем так называемый **SSH-Jump Server** ( *ssh -J* ) в качестве которого выступает хост в лблаке с *белым* ip - **bastion**. 
Такое подключение можно реализовать набрав в удалённом терминале команду 
```
ssh -i ~/.ssh/appuser -A -J appuser@62.84.118.41 appuser@10.128.0.27
```
Для создания подключения без указания промежуточного хоста нужно добавить следующие директивы в конфигурации ssh подключений **~/.ssh/config**:
```
Host bastion
    HostName 62.84.118.41
    User appuser
    IdentityFile ~/.ssh/appuser
    ForwardAgent yes
Host int
    HostName 10.128.0.27
    User appuser
    IdentityFile ~/.ssh/appuser
    ForwardAgent yes
    ProxyJump bastion
```

После этого для подключения к внутреннему хосту достаточно набрать его алиас:

```
ssh int
```

#### Установка и настройка VPN сервера PRITUNL. Создание файла для подключения к VPN.  (Основное задание)

Для установки PRITUNL пришлось изменить адрес репозитория в предложенном файле [setupvpn.sh](https://github.com/Otus-DevOps-2021-08/alexeybobovsky_infra/VPN/setupvpn.sh) (c *xenial* на *bionic*), т.к. иначе  установка завершалась ошибкой. Также пришлось дополнительно устанавливать *iptables* для корректной настройки и старта VPN. 

Для подключения в VPN сгенерён файл [cloud-bastion.ovpn](https://github.com/Otus-DevOps-2021-08/alexeybobovsky_infra/VPN/cloud-bastion.ovpn)

#### Реализация использования  валидного  SSL сертификата  для  панели  управления  VPN сервера PRITUNL (Дополнительное задание)

Для бесплатной генерации SSL серта традиционно еспользуется сервис **letsencrypt.org**. Ограничение использования при котором требуется зареганный домен обходится использованием сервиса **sslip.io**. В вебморде **PRITUNL** в настройках указывается домен **62.84.118.41.sslip.io** и сервис самостоятельно проходит проверку владения доменом, получает сертификат от letsencrypt и подкладывает его в нужное место, после чего при обращениии из браузера по [этому](https://62.84.118.41.sslip.io) адресу  предупреждения о возможно опасном содержимом уйдут.

## Деплой тестового приложения в Yandex Cloud<a name="cloud-testapp"></a>

### План работы

* Установка и настройка yc CLI для работы с аккаунтом;
* Создание хоста с помощью CLI;
* Установка на нем ruby и MongoDB для работы тестового приложения;
* Деплой тестового приложения, запуск и проверка его работы.
### Практические задачи

#### Выполнения плана работы ручной установки по сценарию

Всё выполнено - компоненты установились и стартанули штатно.
#### Создание баш скриптов для автоматического выполнения сценария из предыдцщего пункта (Самостоятельная работа)

Как и требовалось, созданы соответствующие bash скрипты
* [install_ruby.sh](https://github.com/Otus-DevOps-2021-08/alexeybobovsky_infra/blob/cloud-testapp/install_ruby.sh)
* [install_mongodb.sh](https://github.com/Otus-DevOps-2021-08/alexeybobovsky_infra/blob/cloud-testapp/install_mongodb.sh)
* [deploy.sh](https://github.com/Otus-DevOps-2021-08/alexeybobovsky_infra/blob/cloud-testapp/deploy.sh)

#### Полная автоматизация создания виртуалки в облаке и разворачивания на ней приложения (Дополнительное задание)

Создание виртуальной машины ы облаке выполняется посредством **yc CLI** вызовом следующей команды:
```
yc compute instance create \
--name reddit-app \
--hostname reddit-app \
--memory=2 \
--create-boot-disk image-folder-id=standard-images,image-family=ubuntu-1604-lts,size=10GB \
--network-interface subnet-name=default-ru-central1-a,nat-ip-version=ipv4 \
--metadata serial-port-enable=1 \
--zone=ru-central1-a \
--metadata-from-file user-data=metadata.yaml
```
В качестве ***startup script, который будет запускаться при создании инстанса*** используется файл [metadata.yaml](https://github.com/Otus-DevOps-2021-08/alexeybobovsky_infra/blob/cloud-testapp/metadata.yaml) который модержит иструкции для **cloud-init** сервиса, отвечающего за провиженинг и развертывание на уровне облака.

Задеплоенное вышеописанным методом приложение на момент тестирования доступно по следующему адресу:
```
testapp_IP = 62.84.118.196 
testapp_port = 9292
```

