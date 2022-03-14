# Déterminez  

## l'endroit où tout ce qui est lié à Docker est stocké (les images, les données des conteneurs actifs, etc) : /var/lib/docker 

root@ubuntu2004:~# cd /var/lib/docker/
root@ubuntu2004:/var/lib/docker# ls
buildkit  containers  image  network  overlay2  plugins  runtimes  swarm  tmp  trust  volumes

## pourquoi est-ce qu'être membre du groupe docker permet de l'utiliser ? 

## Editer le fichier de configuration du Démon Docker

/lib/systemd/system/docker.service
