function [J grad] = nnCostFunction(nn_params, ...
                                   input_layer_size, ...
                                   hidden_layer_size, ...
                                   num_labels, ...
                                   X, y, lambda)
%NNCOSTFUNCTION Implements the neural network cost function for a two layer
%neural network which performs classification
%   [J grad] = NNCOSTFUNCTON(nn_params, hidden_layer_size, num_labels, ...
%   X, y, lambda) computes the cost and gradient of the neural network. The
%   parameters for the neural network are "unrolled" into the vector
%   nn_params and need to be converted back into the weight matrices. 
% 
%   The returned parameter grad should be a "unrolled" vector of the
%   partial derivatives of the neural network.
%

% Reshape nn_params back into the parameters Theta1 and Theta2, the weight matrices
% for our 2 layer neural network
Theta1 = reshape(nn_params(1:hidden_layer_size * (input_layer_size + 1)), ...
                 hidden_layer_size, (input_layer_size + 1));

Theta2 = reshape(nn_params((1 + (hidden_layer_size * (input_layer_size + 1))):end), ...
                 num_labels, (hidden_layer_size + 1));

% Setup some useful variables
m = size(X, 1);
         
% You need to return the following variables correctly 
J = 0;
Theta1_grad = zeros(size(Theta1));
Theta2_grad = zeros(size(Theta2));

% ====================== YOUR CODE HERE ======================
% Instructions: You should complete the code by working through the
%               following parts.
%
% Part 1: Feedforward the neural network and return the cost in the
%         variable J. After implementing Part 1, you can verify that your
%         cost function computation is correct by verifying the cost
%         computed in ex4.m
%
% Part 2: Implement the backpropagation algorithm to compute the gradients
%         Theta1_grad and Theta2_grad. You should return the partial derivatives of
%         the cost function with respect to Theta1 and Theta2 in Theta1_grad and
%         Theta2_grad, respectively. After implementing Part 2, you can check
%         that your implementation is correct by running checkNNGradients
%
%         Note: The vector y passed into the function is a vector of labels
%               containing values from 1..K. You need to map this vector into a 
%               binary vector of 1's and 0's to be used with the neural network
%               cost function.
%
%         Hint: We recommend implementing backpropagation using a for-loop
%               over the training examples if you are implementing it for the 
%               first time.
%
% Part 3: Implement regularization with the cost function and gradients.
%
%         Hint: You can implement this around the code for
%               backpropagation. That is, you can compute the gradients for
%               the regularization separately and then add them to Theta1_grad
%               and Theta2_grad from Part 2.
%
out = zeros(m, num_labels);
for count=1:num_labels
	out(:, count) += (y == count * ones(m, 1));
end

z2 = [ones(m, 1), X] * Theta1';
a2 = sigmoid(z2);	% m * hidden_layer_size

z3 = [ones(m, 1), a2] * Theta2';
h = sigmoid(z3);	% m * num_labels

J = sum(sum(- out .* log(h) - (1-out) .* log(1-h), 1)) / m + lambda * (sum(sum(Theta1(:, 2:end) .^ 2, 1)) + sum(sum(Theta2(:, 2:end) .^ 2, 1))) / (2*m);

delta3 = h - out;	% m * num_labels
delta2 = (delta3 * Theta2)(:, 2:end) .* a2 .* (1-a2);	% m * hidden_layer_size
delta1 = (delta2 * Theta1)(:, 2:end) .* X .* (1-X);	% m * input_layer_size

Theta1_grad = delta2' * [ones(m, 1), X] / m + lambda * [zeros(hidden_layer_size, 1), Theta1(:, 2:end)] / m;	% hidden_layer_size * (input_layer_size + 1)
Theta2_grad = delta3' * [ones(m, 1), a2] / m + lambda * [zeros(num_labels, 1), Theta2(:, 2:end)] / m;	% num_labels * (hidden_layer_size  +1)





% -------------------------------------------------------------

% =========================================================================

% Unroll gradients
grad = [Theta1_grad(:) ; Theta2_grad(:)];


end
