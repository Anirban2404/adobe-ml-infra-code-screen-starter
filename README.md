# Tic-Tac-Toe ML Infra Engineer Code Screen Code 
Anirban Bhattacharjee

This repo contains starter code that can be used in completing Adobe Research's
[ML Infrastructure Engineer code
screen](https://tic-tac-toe.ethos61-stage-va7.ethos.adobe.net/doc/infra/instructions.html).

Anyone completing this code screen may use (and modify) this code in their
submission.

## License

This code is licensed under the MIT open source license. See
[./LICENSE](LICENSE) for details.

Tic-Tac-Toe is an exceedingly popular game, and the tictactoe game system should be designed for high availability and scalability. 



### High Availability and Scalability Implementation:
The game API service in the submission needs to have two or more replicas. The below command will start the docker containers with a selected number of replicas.

```
docker compose up -d --scale game=<<number of replicas>>
e.g.  docker compose up -d --scale game=2
```

When a replica is up, the game system can accept API requests for any active or complete game and should be able to create new games. If one replica goes down, no state is lost. 

**Design details:**
Pickle is used for serializing Python object structures, and it is stored as a binary file on a disk. The Pickle file of the Game registry dictionary is created during the save game phase, and it is stored in data_dir.

Docker volume is used for persisting data generated by and used by Docker containers. All the tictactoe game states will be saved after a move from a player, and it is stored in the pickle file residing in the docker volume data directory (data_dir). Pickle files are stored in the data_dir, and it is mounted as docker volume to make it fail-safe. If the server fails, the user can restart and load the last known tictactoe game state from the pickle file.

Game in the local containers is accessible via port _8080_ (see dockerfile). However, they are masked behind the Nginx load balancer. Without Nginx or load balancer, the tictactoe host machine can only bind an unallocated port to the container. It will result in `Bind for 0.0.0.0:8080 failed: port is already allocated error for additional game service.`


**nginx.conf** file is responsible for forwarding the request from port _4000_ to _game:8080_ ( _see ```proxy_pass http://game:8080;``` at line 9_). The port _4000_ is forwarded to port _5000_ of the docker container, and the tictactoe application can be accessed at `http://localhost:5000/...`

The **architecture** is shown below -

![alt text](https://github.com/Anirban2404/adobe-ml-infra-code-screen-starter/blob/development/tictactoe.drawio.png)
