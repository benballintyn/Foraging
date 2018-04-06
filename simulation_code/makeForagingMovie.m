function [mov] = makeForagingMovie(R,rtimes,r_acc,RdecayVals,tmax,pos,dxs,dys,dtperframe)
xsize = size(R{1},1);
ysize = size(R{1},2);
h=figure; set(h,'Visible','off')
frame_num = 0;
cur_r = 1;
curR=R{1};
maxR = max(max(R{1}));
minR = min(min(R{1}));
for i=1:dtperframe:tmax
    if (cur_r < length(rtimes) && i >= rtimes(cur_r+1))
        cur_r = cur_r+1;
        curR = R{cur_r};
    else
        curR = R{cur_r}*RdecayVals(i);
    end
    frame_num = frame_num+1;
    disp(['Capturing frame #' num2str(i)])
    cla(gca)
    imagesc(curR); colormap(jet); xlabel('x'); ylabel('y'); h = colorbar(); ylabel(h,'Reward Value')
    caxis([minR maxR])
    hold on;
    p1 = [pos(1,i) pos(2,i)]; p2 = [pos(1,i)+dxs(i)*1000000 pos(2,i)+dys(i)*1000000];
    dp = p2-p1;
    plot([p1(1) ; p2(1)],[p1(2) ; p2(2)],'k','LineWidth',5)
    hold on;
    plot(pos(1,i),pos(2,i),'o','Color','w','MarkerFaceColor','w','MarkerSize',20);
    set(gca,'Ydir','normal','XTick',[1 xsize/2 xsize],'YTick',[1 ysize/2 ysize])
    title(['Accumulated reward = ' num2str(r_acc(i))])
    F = getframe(gcf);
    frames(:,:,:,frame_num) = F.cdata;
end
disp('Making Movie...')
mov = immovie(frames);
implay(mov)
foraging_vid = VideoWriter('foraging_vid.avi');
open(foraging_vid)
writeVideo(foraging_vid,mov)
close(foraging_vid)
end

