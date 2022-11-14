%% Initialization
clc
N=2000;
dt=0.1;
m=1;
k=0.1;
x=zeros(N,1);
v=ones(N,1);
f1=figure;
f2=figure;
%% Euler Harmonic oscillation
for i=1:N
    x(i+1)=x(i)+v(i)*dt;
    v(i+1)=v(i)-k*x(i)/m*dt;
    hold on
end
plot(x)

xEuler=x;
vEuler=v;

%% LeapFrog Harmonic oscillation
x=zeros(N,1);
v=ones(N,1);
xHalf=zeros(N,1);
for i=1:N
    xHalf(i)=x(i)+v(i)*dt/2;
    v(i+1)=v(i)-k*xHalf(i)/m*dt;
    x(i+1)=xHalf(i)+v(i+1)*dt/2;
end
plot(x)
legend('Euler','Leapfrog')
xlabel('t [\Deltat]')
ylabel('r(t)')
xLeapFrog=x;
vLeapFrog=v;
%% Energy calculation
potEnergyEuler=zeros(N,1);
potEnergyLeapFrog=zeros(N,1);
kinEnergyEuler=zeros(N,1);
kinEnergyLeapFrog=zeros(N,1);
totEnergyEuler=zeros(N,1);
totEnergyLeapFrog=zeros(N,1);
for i=2:N
    potEnergyEuler(i)=1/2*k*xEuler(i)^2;
    potEnergyLeapFrog(i)=1/2*k*xLeapFrog(i)^2;
    kinEnergyEuler(i)=1/2*m*vEuler(i)^2;
    kinEnergyLeapFrog(i)=1/2*m*vLeapFrog(i)^2;
    totEnergyEuler(i)=potEnergyEuler(i)+kinEnergyEuler(i);
    totEnergyLeapFrog(i)=potEnergyLeapFrog(i)+kinEnergyLeapFrog(i);
end
figure(f1);
plot(totEnergyEuler)
hold on
plot(totEnergyLeapFrog)
legend('Euler','Leapfrog')
xlabel('t [\Deltat]')
ylabel('E(t)')













