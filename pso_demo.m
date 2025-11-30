clc; clear; close all;

%% Khởi tạo các thành phần
nVar = 10;                     % Số chiều của bài toán
VarMin = -5.12;                % Giới hạn dưới
VarMax =  5.12;                % Giới hạn trên

nPop = 40;                     % Số lượng hạt
MaxIt = 200;                   % Số vòng lặp

w = 0.72;                      % Trọng số quán tính
c1 = 1.5;                      % Hệ số nhận thức 
c2 = 1.5;                      % Hệ số xã hội 

Vmax = 0.2*(VarMax-VarMin);
Vmin = -Vmax;

%% Hàm mục tiêu
rastrigin = @(x) sum(x.^2 - 10*cos(2*pi*x) + 10);

%% Khởi tạo quần thể
particle.Position = [];
particle.Velocity = [];
particle.Cost = [];
particle.Best.Position = [];
particle.Best.Cost = [];

pop = repmat(particle, nPop, 1);
GlobalBest.Cost = inf;

for i = 1:nPop
    pop(i).Position = VarMin + rand(1,nVar).*(VarMax - VarMin);
    pop(i).Velocity = zeros(1,nVar);

    pop(i).Cost = rastrigin(pop(i).Position);

    pop(i).Best.Position = pop(i).Position;
    pop(i).Best.Cost = pop(i).Cost;

    if pop(i).Best.Cost < GlobalBest.Cost
        GlobalBest = pop(i).Best;
    end
end

%% Vòng lặp PSO chính
BestCost = zeros(MaxIt,1);

for it = 1:MaxIt
    for i = 1:nPop

        % Cập nhật vận tốc
        pop(i).Velocity = w*pop(i).Velocity ...
            + c1*rand(1,nVar).*(pop(i).Best.Position - pop(i).Position) ...
            + c2*rand(1,nVar).*(GlobalBest.Position - pop(i).Position);

        % Giới hạn vận tốc
        pop(i).Velocity = max(pop(i).Velocity, Vmin);
        pop(i).Velocity = min(pop(i).Velocity, Vmax);

        % Cập nhật vị trí
        pop(i).Position = pop(i).Position + pop(i).Velocity;

        % Giới hạn vị trí
        pop(i).Position = max(pop(i).Position, VarMin);
        pop(i).Position = min(pop(i).Position, VarMax);

        % Tính cost
        pop(i).Cost = rastrigin(pop(i).Position);

        % Cập nhật pbest
        if pop(i).Cost < pop(i).Best.Cost
            pop(i).Best.Position = pop(i).Position;
            pop(i).Best.Cost = pop(i).Cost;

            % Cập nhật gbest
            if pop(i).Best.Cost < GlobalBest.Cost
                GlobalBest = pop(i).Best;
            end
        end
    end

    BestCost(it) = GlobalBest.Cost;
    fprintf('Vòng lặp thứ %d: gbest = %.6f\n', it, BestCost(it));
end

%% Đồ thị hội tụ
figure;
plot(BestCost, 'LineWidth', 2);
xlabel('Vòng lặp');
ylabel('Phương án tốt nhất tìm được');
title('Biều đổ biểu thị chạy thuật toán PSO');
grid on;

%% Kết quả cuối
disp('-------------------------');
disp('Nghiệm tối ưu tìm được:');
disp(GlobalBest.Position);

disp('Giá trị hàm nhỏ nhất:');
disp(GlobalBest.Cost);
