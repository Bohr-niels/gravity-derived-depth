function [output]=GGM(free,control,check,d,range)
%usage:    GGM(free,control,check,-8000,'142.6/147.3/23/27')
%         free&control&check��λ����
%d=-8000 Ϊ�ο�ˮ��
%range='142.6/147.3/23/27' Ϊʵ������

%-------------------------------����׼��------------------------------------

order=['surface -R',range,' -I1m -Gfree.grd -T0.25 -C0.1 -Vl'];
gmt(order,free);

control_free=gmt('grdtrack -Gfree.grd -h',control(:,1:2));
%% 
%---------------------------��������ܶȲ�---------------------------------
stdlist=[];
roulist=[];
xianguanlist=[];
for rou=0.5:0.1:5%��һ����Χ��Ѱ��������ܶȲ�����޸ķ�Χ
roulist=[roulist rou];

control_short=(control(:,3)-d)*2*3.1415*6.67259*10^-8*rou*100000;

control_long=control_free.data(:,3)-control_short;

order=['surface -R',range,' -I1m -Glong.grd -T0.25 -C0.1 -Vl'];
gmt(order,[control(:,1:2) control_long]);

gmt('grdmath free.grd long.grd SUB = short.grd')

tem1=num2str(2*3.1415*6.67259*10^-8*rou*100000);
order1=['grdmath short.grd ',tem1,' DIV ',num2str(d),' ADD = ggm.grd'];
gmt(order1);

ggm_depth=gmt('grdtrack -Gggm.grd -h',check(:,1:2));
stdinfo=std(ggm_depth.data(:,3)-check(:,3));
temcorr=corrcoef(ggm_depth.data(:,3),check(:,3));
xianguanlist=[xianguanlist temcorr(2)];

stdlist=[stdlist stdinfo];
%-----------------------GGMˮ���---------------------------------------------------
[minstd,index]=min(stdlist);
suit_rou=roulist(index);
%% 
control_short=(control(:,3)-d)*2*3.1415*6.67259*10^-8*suit_rou*100000;

control_long=control_free.data(:,3)-control_short;

order=['surface -R',range,' -I1m -Glong.grd -T0.25 -C0.1 -Vl'];
gmt(order,[control(:,1:2) control_long]);

gmt('grdmath free.grd long.grd SUB = short.grd')

tem1=num2str(2*3.1415*6.67259*10^-8*suit_rou*100000);%���GGM.grd 
order1=['grdmath short.grd ',tem1,' DIV ',num2str(d),' ADD = ggm.grd'];
gmt(order1);

ggm_depth=gmt('grdtrack -Gggm.grd -h',check(:,1:2));
%% ���
output.stdinfo=minstd;%�ܶȲ�
output.rou=suit_rou;%��׼��
output.d=d;%�ο����
output.detaD=ggm_depth.data(:,3)-check(:,3);%���˵���Ȳ�ֵ
output.rou_std_list=[roulist' stdlist' xianguanlist'];%��ͬ�ܶ������ϵ���ͱ�׼�������ͼ
end