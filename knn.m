

function [accuracy,ypred] = knn(k,data,labels,t_data,t_labels)
%KNN_: classifying using k-nearest neighbors algorithm. The nearest neighbors
%search method is euclidean distance

%Input:
%       - k: number of nearest neighbors
%       - data: (NxD) training data; N is the number of samples and D is the
%       dimensionality of each data point
%       Here is all the centers (MxN)
%       - labels: training labels (clusters' labels)
%       - t_data: (MxD) testing data; M is the number of data points and D
%       is the dimensionality of each data point
%       - t_labels: testing labels (default = [])

%Output:
%       - predicted_labels: the predicted labels based on the k-NN
%       algorithm
%       - accuracy: if the testing labels are supported, the accuracy of
%       the classification is returned, otherwise it will be zero.

%initialization
predicted_labels=zeros(size(t_data,1),1);
ed=zeros(size(t_data,1),size(data,1)); %ed: (MxN) euclidean distances 
ind=zeros(size(t_data,1),size(data,1)); %corresponding indices (MxN)
k_nn=zeros(size(t_data,1),k); %k-nearest neighbors for testing sample (Mxk)
%calc euclidean distances between each testing data point and the training
%data samples
for test_point=1:size(t_data,1)
    for train_point=1:size(data,1)
        %calc and store sorted euclidean distances with corresponding indices
        ed(test_point,train_point)=sqrt(...
            sum((t_data(test_point,:)-data(train_point,:)).^2));
    end
    [ed(test_point,:),ind(test_point,:)]=sort(ed(test_point,:));
end
%find the nearest k for each data point of the testing data
k_nn=ind(:,1:k);
nn_index=k_nn(:,1);
%get the majority vote 
for i=1:size(k_nn,1)
    options=unique(labels(k_nn(i,:)'));
    max_count=0;
    max_label=0;
    for j=1:length(options)
        L=length(find(labels(k_nn(i,:)')==options(j)));
        if L>max_count
            max_label=options(j);
            max_count=L;
        end
    end
    predicted_labels(i)=max_label;
end

ypred=predicted_labels;
%calculate the classification
if isempty(t_labels)==0
    accuracy=length(find(predicted_labels==t_labels))/size(t_data,1);
end

