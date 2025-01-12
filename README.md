# Kepler11 

NE PAS METTRE DE SECRET DANS .ENV

## Ajouter l'utilisateur au group sudo 

```sh 
sudo usermod -aG sudo <user>
```

## Installer git

```sh 
sudo apt update
```

```sh 
sudo apt install git -y
```


## Ajouter l'utilisateur au group sudo 

```sh 
git clone --depth 1 --filter=blob:none https://github.com/j-renevier/kepler11.git

cd kepler11

git sparse-checkout init --cone

git sparse-checkout set docker/services/homeassistant
```
