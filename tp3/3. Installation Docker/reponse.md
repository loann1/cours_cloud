# Déterminez  

## l'endroit où tout ce qui est lié à Docker est stocké (les images, les données des conteneurs actifs, etc) : /var/lib/docker 

```sh
root@ubuntu2004:~# cd /var/lib/docker/

root@ubuntu2004:/var/lib/docker# ls

buildkit  containers  image  network  overlay2  plugins  runtimes  swarm  tmp  trust  volumes
```

## pourquoi est-ce qu'être membre du groupe docker permet de l'utiliser ? 
```sh
Le groupe docker possède les droits root SEULEMENT sur la partie gestion de docker et de son service. 
```

## le path du fichier de conf de Docker

```sh
/etc/docker
```

## Editer le fichier de configuration du Démon Docker

(voir fichier daemon.json)

## 4. Lancement des conteneurs 

```sh
docker run --name nginx -v /var/lib/nginx.conf -v /var/lib/index.html -p 8888:80 --cpu-quota 2000 --memory 7000 --user vagrant nginx 
```

