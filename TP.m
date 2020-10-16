%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%                     TRANSMISSION DE L'INFORMATION                     %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Ce code vous est une simple proposition suivant à peu de chose pres le
% sujet du TP. Libre à vous de le modifier comme vous le souhaitez.

% METTEZ TOUT EN COMMENTAIRE AVANT DE COMMENCER LE TP
% AU FUR ET A MESURE DE VOTRE AVANCEMENT, TESTEZ VOTRE CODE...


clear all 
close all
clc

disp('Le message suivant va etre compresse (par Huffman), transmis, puis decompresse :'),

texte = 'TESTDETI';
%texte = 'CECIESTUNEDEMOCETTEPHRASEVAETRECOMPRESSEEPARLECODEDEHUFFMAN';
%texte = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';

disp(texte);

%% 1ere partie du TP : cryptage
% *************************************************************************

% Chiffrement
cle = input('Quelle est la cle de chiffrement ?');
texte = cryptage(texte, cle);
disp(' ');
disp('Le cryptogramme est :');
commentaire = texte;
disp(commentaire);
                                                                                     
pause

%% 2eme partie du TP : codage de Huffman
% *************************************************************************
 %I/Codage de source
 % *************************************************************************
% 1.Entropie


H = entropie(texte);       %calcul de l'entropie de l'information 
disp(' ');
disp('L''entropie de la source est :');
commentaire = strcat('H=',num2str(H),' bits');  
disp(commentaire);    %affichage de l'entropie calculé   


% 3.Compression de Huffman
[texte_compr,arbre] = huffman_compr(texte); %Compression de l'information en utilisant l'algorithme de Huffman 

disp(' ');
disp('Le code calcule est :');
for i = 1 : length(arbre)
    commentaire = strcat(char(arbre(i).info),'-->',arbre(i).valeur);
    disp(commentaire);      % Affichage du Code de Huffman Calculé 
end

% 4. Longueur moyenne des mots de code

long=0;
for i = 1 : length(arbre)
    long=long+length(arbre(i).valeur);    %Longueur du code calculé  
end
Long_moy = long/length(arbre); % Calcul de la longueur moyenne 
disp(' ');
disp('La longueur moyenne des symboles de code est :');
commentaire = strcat('n=',num2str(Long_moy),' bits'); % Affichage de la longueur moyenne 
disp(commentaire);

% Calcul du taux de compression

% Sans compression
Nb_bits = 8;    % On suppose que chaque charactere du table ASCII est code sur Nb_bits bits
disp(' ');
disp('Sans compression, le nombre de symboles binaires par lettre source est :');
commentaire = strcat('n=',num2str(Nb_bits),' bits');
disp(commentaire);
%Taille de l'information Sans Compression 
Nb_bits_SC = length(texte)*Nb_bits;

% Taille de l'information Avec compression
Nb_bits_AC = length(texte_compr);

Taux = (1-(Nb_bits_AC/Nb_bits_SC))*100; % Calcul du taux de compression 
disp(' ');
disp('Le taux de compression est :');
commentaire = strcat( 'T=', num2str(Taux), ' %');
disp(commentaire);

% 2eme partie du TP : codage de canal
%*************************************************************************

%Codes correcteur d'erreur
%--------------------------------------------------------------

%Matrice génératrice
G=[1 1 1 0 0 0 0 ;...
   1 0 0 1 1 0 0 ;...
   0 1 0 1 0 1 0 ;...
   1 1 0 1 0 0 1];

%Taille du vecteur d'info et de code
[k,n] = size(G); 

%Nombre de mots à coder dans la variable texte_compr


%On découpe le vecteur compressé en paquets de k digits et on les code
flag=0;
if (mod(length(texte_compr),k)==0)  %Si la longeur de texte_compr est un multiple de K 
    Nb_info = length(texte_compr)/k;    
else      %Si la longeur de texte_compr n'est pas un multiple de K 
    Nb_info = floor((length(texte_compr)/k))+1; 
    z = Nb_info*k-length(texte_compr);
    texte_compr=[texte_compr zeros(1,z )] ;   % On divise texte_compr en K mots avec 'z' Zeros rajoutés pour le dernier mots 
    flag=1; % Le flag permet de connaitre si on a rajouté les zeros à la fin
end

Text_compr_grid = reshape(texte_compr,k,Nb_info);
Text_compr_grid=Text_compr_grid';


%------Calcul du code et organisation des mots sous forme matricielle :
code = Text_compr_grid*G;
for i=1:length(code)
    O=find(code>1); 
    if (mod(code(O),2)==0) 
        code(O)=0;
    end

    if (mod(code(O),2)==1)
        code(O)=1;
    end
end
p=size(code);
code = reshape( code',1,p(1)*p(2)); 
%-----------------------------------------------------------------------

% PARAMETRES POUR SIMULINK
% Simulation de la transmission
fe_simulink = 50000;
% Durée / amplitude des symboles
Tsymbole_simulink = 70;
Asymbole_simulink = 5;
code_simulink = [code];
% Vecteur d'entrée de la simulation
t_simulink = [0:length(code_simulink)-1]*Tsymbole_simulink/fe_simulink;
entree_simulink = [t_simulink', code_simulink'];

%% SIMULINK
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fp=50;
sim('simulation.mdl')

f=linspace(0,fe_simulink,length(out_simulink));     % initialisation du vecteur des frequences 
T=linspace(0,1/fe_simulink,length(out_simulink));  % % initialisation du vecteur de temps

figure
subplot(2,1,1)
plot(T,out_simulink)   %Tracé de l'allure temporel du sortie de secteur
title('Temporel')
xlabel('t (milliseconds)')
ylabel('X(t)')

subplot(2,1,2)
plot(f,20*log10(abs(fft(out_simulink)))) %Tracé de l'allure frequentielle du sortie de secteur
title('Frequentiel')
xlabel('f (Hz)')
ylabel('|X(f)|')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Analyse des erreurs
% --------------------------------------------------------------

% Analyse du code
Ndecalage = 2; % Décalage lié à la transmission 
code_emis =code ;
code_recu =out_simulink1 ;
code_recu =[code_recu(Ndecalage+1:length(code_recu))' zeros(1,Ndecalage)]; %Ajustation du code recu pour supprimer le décalage

e=eye(n,n);% Vecteurs d'erreur

% Détection/correction des erreurs
% --------------------------------------------------------------

% Matrice de contrôle
H = [0 0 0 1 1 1 1; ...
     0 1 1 0 0 1 1; ...
     1 0 1 0 1 0 1];
 
code_emis=reshape(code_emis,n,Nb_info)'; %Formulation matricielle du code Emis 

% Correction des erreurs
code_recu=reshape(code_recu,n,Nb_info)';%Formulation matricielle du code reçu 
s=mod(code_recu*H',2);   % Calcul du syndrome du code reçu
S=e*H' ;  %Tableau des syndromes de toutes les erreurs possibles 
code_corrige=code_recu.*0;

for i=1:Nb_info
    for j= 1:n
        if all(s(i,:)==S(j,:))  %On verifie si un des syndromes de l'information reçu est identiques a l'un des syndromes possibles  
          code_corrige(i,:) = mod(code_recu(i,:)-e(j,:),2);  %Correction de l'Information
        else
          code_corrige(i,:) = code_recu(i,:);    %sinon on garde l'Information non modifie
        end
    end
end


% Nombre d'erreur

[Ta q] = taux_erreur(code_emis,code_recu);  %calcul du normbre d'erreurs et du taux de compression avant Correction
[Ta2 q2] = taux_erreur(code_corrige,code_emis);%calcul du normbre d'erreurs et du taux de compression aprés Correction

info_corrigee=code_corrige(:,[3,5:7]); %Decodage de l'information ( Exraction des bits d'information du code reçu )  
p=size(info_corrigee);   
info_corrigee=abs(reshape(info_corrigee',1,p(2)*p(1))); %Mettre l'information sous forme d'un flux binaire


if (flag==1)    %On supprime les bits à la fin si necesssaire
    info_corrigee = info_corrigee(1:end-z);
    texte_compr = texte_compr(1:end-z);
end


% Décompression 

texte_envoye = huffman_decompr(texte_compr,arbre);
texte_envoye = decryptage(texte_envoye, cle);
disp(' ');
disp('Le message décompressé (SANS transmission) est :');
disp(texte_envoye);

texte_recu_corrige = huffman_decompr(info_corrigee,arbre);
texte_recu_corrige = decryptage(texte_recu_corrige, cle);
disp(' ');
disp('Le message décompressé (AVEC transmission, AVEC code correcteur) est :');
disp(texte_recu_corrige);
disp(' ')


% Taux d'erreur par caractère

% Sans prise en compte de la redondance
nb_err = q; 
tau_err = Ta ; 
disp('Taux d''erreur caractère (SANS code correcteur):');
fprintf('  - Nombre d''erreur : %i\n',nb_err)
fprintf('  - Taux d''erreur : %.2f%%\n', tau_err);
% En tenant compte de la redondance (code correcteur)
nb_err = q2; 
tau_err = Ta2; 
disp('Taux d''erreur caractère (AVEC code correcteur) :');
fprintf('  - Nombre d''erreur : %i\n',nb_err)
fprintf('  - Taux d''erreur : %.2f%%\n', tau_err);

%% Evolution des taux d'erreurs en fonction du RSB
% *************************************************************************
%Pour le texte 'TESTDETI'
rsb=[-5,-2,-1, -0.5, 1, 2, 5];
tau_err=[ 14.29 11.43 8.57 5.71 0 0 0 ];

figure;
plot(rsb, tau_err); title ('Evolution de taux d erreur en fonction de rsb');
