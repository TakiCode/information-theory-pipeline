%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%                 FONCTION DE COMPRESSION SELON HUFFMAN                 %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Cette fonction suit l'algorithme de Huffman
% en s'appuyant sur les frequences d'apparition
% des symboles dans le message à compresser
%

function [data_zipped,code] = huffman_compr(donnees)

% Conversion des donnees en entiers non signes (0 à 255)
data_int = uint8(donnees);

% Calcul des frequences d'apparition des lettres dans la phrase
f = histc(data_int(:)', 0:255);      % Comptage des fréquences data_int dans une intervalle 0-255 
f = f(:)'/sum(f);        % Vecteur avec les probabilités d’appariations de toutes les fréquences, 
indice_lettres = find(f);     % Suppression des entiers non présents, on stocke les indices des probabilités non nuls
f = f(indice_lettres);  % Les probabilités correspondantes aux fréquences d'appariation


% Validation
if abs(sum(f) - 1) > 1E-10 | sum(f <= 0)
    disp('!!! Erreur dans le calcul des frequences !!!');
    disp('!!! Somme differente de 1 ou valeurs negatives !!!');
    pause;
end

% Initialisation des vecteurs
N = length(f);
NN = N - 1;
Arbre = zeros(N,N);
Branche_zero = zeros(NN,1); 
Branche_un = zeros(NN,1);

% Premiere etape
for k = 1 : N
    Arbre(k,1) = f(k);
end

% Etapes suivantes
for i = 1 :NN
    
    % Les deux plus petites valeurs
    [valeur, indice]=sort(Arbre(:,i));      % Tri par ordre croissant
    ind1 = indice(1) ;                    % Frequence la plus petite
    ind2 = indice(2);                    % Frequence juste plus grande

    % Ecriture de l'etape suivante dans l'arbre
    Arbre(:,i+1) = Arbre(:,i);      % copie de la premiere colonne dans la deuxieme 
    Arbre(ind2,i+1) = 9;         % valeur aleatoire pour remplir les trous dans l'arbre 
    Arbre(ind1,i+1) = Arbre(ind1,i) + Arbre(ind2,i);  %calcul de la colonne suivante

    % Memorisation de la branche
    Branche_zero(i) = ind1;  
    Branche_un(i) = ind2;
end

% Calcul du code
for i = 1 : N
    code(i).valeur = [];
end

for i = NN : -1 : 1
    ind1 = Branche_zero(i);
    ind2 = Branche_un(i);
    bit = code(ind1).valeur;
    code(ind1).valeur = [bit,'1'];
    code(ind2).valeur = [bit,'0'];
end
for i = 1 : N
    code(i).frequence = f(i);
end

% Association du mot de code et du mot d'information
data_zipped = ' ';
for i = 1 : length(data_int)
    for j = 1 : length(indice_lettres)
        if ((indice_lettres(j) - 1) == data_int(i))
            indice = j;
        end
    end
    data_zipped = strcat(data_zipped,code(indice).valeur);
    code(indice).info = data_int(i);
end

data_zipped = uint8(data_zipped)>uint8('0');
