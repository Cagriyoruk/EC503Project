function [c,labels] = kmeans(X, T, Ytrain)
%  Ytrain is 1*m
k = 5;
[m,d]=size(X);

idx=randperm(m);
c=zeros(k,d);
c(1:k,:)=X(idx(1:k),:);
labels = 1:k;
% Norms of the samples
norm_x = full(sum(X.^2,2));

% Fake initial assignment
cluster=ones(1,m);

for iter=1:T
    
    % assign to centers
    old_cluster=cluster;
%     obj(iter)=0;
    % calculate matrix of squared distances between centers and points
    norm_c = full(sum(c.^2,2));
    dists = repmat(norm_x',k,1) + repmat(norm_c,1,m) - 2*full(c*X');
    [mn,cluster]=min(dists);
%     obj(iter)=sum(mn);
    if old_cluster==cluster
        break;
    end

    % update centers
    for i=1:k
        c(i,:)=mean(X(cluster==i,:));
    end  
end
cluster(2,:)=Ytrain;
cluster(2,:)=[ones(1,10000),2*ones(1,10000),3*ones(1,10000),4*ones(1,10000)...
    5*ones(1,10000),ones(1,10000)];
for center = 1:k
    labels(center)=mode(cluster(2,find(cluster(1,:)==k)));
end

end
