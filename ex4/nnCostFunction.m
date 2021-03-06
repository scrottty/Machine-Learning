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

% Add bias value
a1 = [ones(m,1) , X];

% Calculate hidden layer
z2 = a1 * Theta1';
% Apply Sigmoid
a2 = sigmoid(z2);
% Add bias
a2 = [ones(size(a2,1),1) , a2];

% Calculate Output Layer
z3 = a2 * Theta2';
% Apply Sigmoid
a3 = sigmoid(z3);

% Convert y to matrix
y_vect = eye(num_labels);
y_vect = y_vect(y,:);

% Calculate value within sums
a = -y_vect .* log(a3) - (1-y_vect) .* log(1-a3);

% Calc Unregulated cost
J = sum(sum(a)) / m;

% Calc Regluarisation
J = J + lambda/(2*m) * ( sum(sum(Theta1(:,2:end).^2)) + sum(sum(Theta2(:,2:end).^2)) );
    
% Back Propagation
d3 = a3 - y_vect;
d2 = (Theta2(:,2:end)' * d3')' .* sigmoidGradient(z2);
% Accumlator for each layer
Delta1 = d2' * a1;
Delta2 = d3' * a2;

% Gradient at each layer
Theta1_grad = Delta1/m;
Theta2_grad = Delta2/m;

Theta1_reg = [zeros(size(Theta1,1),1) , Theta1(:,2:end)];
Theta2_reg = [zeros(size(Theta2,1),1) , Theta2(:,2:end)];

Theta1_grad = Theta1_grad + lambda/m * Theta1_reg;
Theta2_grad = Theta2_grad + lambda/m * Theta2_reg;





% -------------------------------------------------------------

% =========================================================================

% Unroll gradients
grad = [Theta1_grad(:) ; Theta2_grad(:)];



end
