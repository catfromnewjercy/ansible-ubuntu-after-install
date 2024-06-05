*   Создаём пользователя ansible на компьютере управления

```
adduser ansible
```
*   Добавляем пользователя в группу sudo

```
usermod -aG sudo ansible
```

*   Проваливаемся в shell от имени пользователя ansible

```
su ansible
```

*   Генерируем пару ключей для ssh

```
$ ssh-keygen -t rsa
```

*   Получаем примерно такой вывод:
```
Generating public/private rsa key pair.
Enter file in which to save the key (/home/ansible/.ssh/id_rsa):
Created directory '/home/ansible/.ssh'.
Enter passphrase (empty for no passphrase):
Enter same passphrase again:
Your identification has been saved in /home/ansible/.ssh/id_rsa
Your public key has been saved in /home/ansible/.ssh/id_rsa.pub
The key fingerprint is:
SHA256:qVrmzcZ1wS9X3IeAe4ej5zV9RSdOMa3H9LbtxcrVlXQ ansible@DESKTOP-5M3HCQC
The key's randomart image is:
+---[RSA 3072]----+
|           .  oo |
|          . . ooE|
|           o =.O*|
|         .. * =.%|
|        S  o = *B|
|       .  o + =.O|
|      +. . + = =o|
|     = oo   . o .|
|    . ..o        |
+----[SHA256]-----+
```

*   Как видим, ключи создались в нашей home директории, в папке .ssh два файла id_rsa - приватный ключ и id_rsa.pub - публичный ключ.


*   Для установки ansible, воспользуемся утилитой pipx
```
apt update && apt install pipx
```
*   Далее, устанавливаем непосредственно ansible
```
pipx install ansible
```

*   Для запуска плейбука, нам необходимо для начала создать пользователя на каждом из серверов для ansible

```
useradd -m -s /bin/bash ansible
```

*   Задаём пароль для пользователя:

```
passwd ansible
````

*   Для запуска нашего плейбука необходимо подготовить файл инвентаризации [a relative link](inventory)

*   В первую очередь указываем путь до нашего приватного сертификата в строчке ansible_ssh_private_key_file

```
ansible_ssh_private_key_file=/home/ansible/.ssh/id_rsa
```

*   Далее, изменяем на необходимые нам адреса для ansible_host, в соответствии настройкам ваших серверов, если есть лишние, то лучше удалить их из файла инвентаризации
*   Группа [all] - включает в себя все хосты.
*   Группа [runtime] - тут указываем сервера предназначенные для runtime
*   Группа [common]  - вспомогательные сервера
*   Группа [historyan] - сервера для historyan
*   Группа [sonatype] - группа, куда будет установлен sonatype-nexus