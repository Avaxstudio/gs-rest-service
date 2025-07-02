### Nisam imao maven paket u linux distribuciji pa sam ga instalirao
sudo apt install maven
## JAVA verzija na mom sistemu je 11.0.27 pa sam instalirao novu
sudo apt install openjdk-17-jdk
## Komanda  
mvn spring-boot:run 
## daje pozitivan output
## Kreiram Dockerfile
## Build image i provera da li radi ispravno preko localhost
## pokretanje Jenkins kontejnera
## Unosenje lozinke koju imam u folderu docker exec jenkins cat /var/jenkins_home/secrets/initialAdminPassword

## Skidam Jenkins docker koji ima vise opcija, to je jdk11 verzija, pa unutar kontejnera instaliram Docker CLI
