close all;
figure;
hold on;

% load('no_pheromone_data.mat');
% plot(data, 'r');
% load('pheromone_data.mat');
% plot(data, 'g');
% load('double_pheromone_data.mat');
% plot(data, 'b');

% load('two_food_sources.mat');
% plot(data(:, 1), 'r');
% plot(data(:, 2), 'b');

load('two_food_sources_unequal_dist.mat');
plot(data(:, 1), 'r');
plot(data(:, 2), 'b');

hold off;