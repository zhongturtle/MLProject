function [ status ] = runAndReportGD(X, y, learning_rate, no_of_iter, fileName, start_cell)
%RUNANDREPORT Run PSO and write it to excel
%   Detailed explanation goes here

% xlswrite(filename, run_testing_error, 'Testing', 'C5');

TEST_RUN=10;

N=size(X,1);
P=0.2;

Xnorm = X;
ynorm = y;

if ~exist('learning_rate' , 'var')
    learning_rate = 0.6;
end

%% Add intercept term

Xnorm = [ ones(size(Xnorm, 1), 1) Xnorm];

theta = zeros(size(Xnorm, 2), 1);

num_of_iter = 3;

result_testing_error = [];
result_training_error = [];

for j = 1:1:num_of_iter

for i=1:1:TEST_RUN

[Train, Test] = crossvalind('HoldOut', N, P);

%[theta,XgBest, cost_hist] = pso(Xnorm(Train,:), ynorm(Train), 20);
[theta, Jhist] = gradientDescentMulti(Xnorm(Train,:), ynorm(Train, :), theta, learning_rate, 2000);
% figure
% title('Costs');
 %num_particles = size(cost_hist, 1);

% for i = 1:num_particles
%    subplot(num_particles, 1, i);
%    plot(cost_hist(i, :));
%    title(sprintf('Particle %d', i));
% end



%--Training error
data_size=size(Xnorm(Train,:),1);

%Y=ones(data_size,1)+sum(Xnorm(Train,:).*repmat(XgBest,data_size,1),2);

Y = Xnorm(Train, :) * theta;

Error=sum(abs(ynorm(Train)-Y));

run_training_error(i,1)=Error;

%--Training error
data_size=size(Xnorm(Test,:),1);

%Y=ones(data_size,1)+sum(Xnorm(Test,:).*repmat(XgBest,data_size,1),2);
[theta, Jhist] = gradientDescentMulti(Xnorm(Test,:), ynorm(Test, :), theta, learning_rate, 2000);

Y = Xnorm(Test, :) * theta;
Error=sum(abs(ynorm(Test)-Y));

run_testing_error(i,1)=Error;


fprintf('Error=%f\n',Error);


end

result_testing_error = [ result_testing_error ; run_testing_error];
result_training_error = [ result_training_error ; run_training_error];
end

% [status_test] = xlswrite(fileName, result_testing_error, 'Testing', start_cell);
% [status_train] = xlswrite(fileName, result_training_error, 'Training', start_cell);

% status = status_test && status_train;
status = 0;
% End of function
end

