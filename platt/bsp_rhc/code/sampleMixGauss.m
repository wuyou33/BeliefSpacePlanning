function samples=sampleMixGauss(gm,params)
    x=0:0.01:3;
    y=-1:0.01:2;
    [x,y]=meshgrid(x,y);
    x=reshape(x,[],1);
    y=reshape(y,[],1);
    f=pdf(gm,[x y]);
    [f_sorted,idx]=sort(f);
    f_sorted=flipud(f_sorted);
    idx=flipud(idx);
    max_f=f_sorted(1);
    %choose max_fs atleast
    samples(:,1)=x(idx(abs(f_sorted-max_f)<1e-5));
    samples(:,2)=y(idx(abs(f_sorted-max_f)<1e-5));
    idx(abs(f_sorted-max_f)<1e-5)=[];
    idx_sub=idx(f_sorted>0.7*max_f);
    remaining_num_samples=params.num_sup_points-size(samples,1);
    if size(idx_sub,1)>remaining_num_samples
        samples_new(:,1)=x(idx_sub(randperm(size(idx_sub,1),remaining_num_samples)));
        samples_new(:,2)=y(idx_sub(randperm(size(idx_sub,1),remaining_num_samples)));
    else
        samples_new(:,1)=x(idx_sub(1:size(idx_sub)));
        samples_new(:,2)=y(idx_sub(1:size(idx_sub)));
    end
    if size(samples_new,1)<2
        fprintf('convergence not guaranteed\n');
    end
    samples(end+1:end+size(samples_new,1),:)=samples_new;
end