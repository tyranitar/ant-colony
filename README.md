# Ant Colony

This is a simulation of an ant colony that demonstrates ant collaboration through the use of _pheromone trails_. The simulation states are divided into 4 layers:

![State map](images/state_maps.jpg)

When the simulation starts, ants crawl out of their nest (center) and randomly traverse the map in search for food (red squares):

![Ant colony](images/ant_colony.jpg)

When an ant finds food, it brings it back to the nest while leaving behind a pheromone trail. When other ants hit a pheromone trail, they follow it towards the food. This allows ants to collaborate indirectly, emulating intelligent behavior:

![Positive feedback](images/pos_feedback_0.jpg)

This allows for efficient food collection, even over long distances, because the ants that find food by following a pheromone trail continue to reinforce the path to the food:

![Positive feedback](images/pos_feedback_1.jpg)

Using pheromone trails has a clear advantage over pure random search:

![Pheromone](images/pheromone.jpg)
