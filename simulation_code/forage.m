function [pos,R,dxs,dys,r_acc,RdecayVals] = forage(x0,y0,xmax,ymax,rtimes,rlocs,rvals,rrad,tvec,dt,Rdx,Rdy,sigma,lambda)
nrewards = length(rtimes);
tauR = length(tvec)/nrewards;
pos = zeros(2,length(tvec));
pos(:,1) = [x0 y0];
xrange = 1:Rdx:xmax; yrange = 1:Rdy:ymax;
[X,Y] = meshgrid(xrange,yrange);
for i=1:(nrewards)
    Rtemp = mvnpdf([X(:),Y(:)],[rlocs(i,1) rlocs(i,2)],[rrad 0; 0 rrad]);
    Rtemp = reshape(Rtemp,length(xrange),length(yrange))*rvals(i);
    Rtemp = Rtemp - max(max(Rtemp))/2;
    R{i} = Rtemp;
end
cur_r = 1;
curR = R{cur_r};
minR = min(min(R{1}));
r_acc = zeros(1,length(tvec));
RdecayVals = zeros(1,length(tvec));
for i=2:length(tvec)
    if (cur_r < (nrewards) && i == rtimes(cur_r+1))
        cur_r = cur_r+1;
        curR = R{cur_r};
        maxR = max(max(curR));
    else
        RdecayVals(i) = exp(-(i-rtimes(cur_r))/tauR);
        curR = R{cur_r}*RdecayVals(i);
        maxR = max(max(curR));
    end
    samplexs = round((pos(1,i-1)-Rdx):Rdx:(pos(1,i-1)+Rdx));
    sampleys = round((pos(2,i-1)-Rdy):Rdy:(pos(2,i-1)+Rdy));
    ptrightx = round(pos(1,i-1)+Rdx); ptrighty = round(pos(2,i-1));
    ptupx = round(pos(1,i-1)); ptupy = round(pos(2,i-1)+Rdy);
    curx = round(pos(1,i-1)); cury = round(pos(2,i-1));
   
    [dx,dy] = gradient(curR(sampleys,samplexs));
    
    newsigma = max(0,sigma - (curR(round(pos(2,i-1)),round(pos(1,i-1)))/maxR));
    newlambda = lambda - (curR(round(pos(2,i-1)),round(pos(1,i-1)))/maxR)*lambda;
    dxydt = newsigma*randn(2,1) + newlambda*[dx(2,2) ; dy(2,2)];
    dxs(i) = dx(2,2); dys(i) = dy(2,2);
    %dxydt = sigma*randn(2,1) + [dx ; dy];
    pos(:,i) = pos(:,i-1) + dxydt;
    pos(1,i) = min(pos(1,i),xmax-1); pos(1,i) = max(pos(1,i),2);
    pos(2,i) = min(pos(2,i),ymax-1); pos(2,i) = max(pos(2,i),2);
    r_acc(i) = r_acc(i-1) + curR(round(pos(2,i)),round(pos(1,i)));
end
end

