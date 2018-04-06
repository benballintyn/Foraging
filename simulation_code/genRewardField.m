function [R] = genRewardField(locs,times,vals,total_time,dt,maxx,maxy)
xrange = 1:maxx; yrange = 1:maxy;
nrewards = length(vals);
R = zeros(maxx,maxy,total_time/dt);
[X,Y] = meshgrid(xrange,yrange);
reward_num = 0;
next_r_time = times(1);
%{
for i=1:(total_time/dt)
    if (mod(i,100) == 0)
        disp([num2str(i/(total_time/dt)*100) '% done'])
    end
    if (i > next_r_time && reward_num < nrewards)
        reward_num = reward_num+1;
        next_r_time = times(reward_num);
    end
    if (reward_num == 0)
        continue;
    else
        Rtemp = mvnpdf([X(:) Y(:)],[locs(reward_num,1) locs(reward_num,2)],[10000 0; 0 10000]);
        Rtemp = reshape(Rtemp,length(xrange),length(yrange));
        R(:,:,i) = Rtemp;
    end
end
%}
for i=1:nrewards
    Rtemp = mvnpdf([X(:),Y(:)],[locs(i,1) locs(i,2)],[10000 0; 0 10000]);
    Rtemp = reshape(Rtemp,length(xrange),length(yrange))*vals(i);
    if (i < nrewards)
        rstart = times(i); rend = times(i+1);
    else
        rstart = times(i); rend = total_time/dt;
    end
    R(:,:,rstart:rend) = repmat(Rtemp,1,1,rend-rstart+1);
end

end

