%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%                          FONCTION ENTROPIE                            %%
%%%%%%%%%%%%%%%%%%%%%%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Cette fonction calcule les frequences d'apparition des 
% symboles dans une source de message
% Elle calcule ensuite l'entropie de la source
 
function e = entropie(d)
 
% Conversion des donn�es en entiers non signes (0 � 255)
data_int = uint8(d);
 
% Calcul des frequences d'apparition des lettres dans la phrase

freq = histc(data_int(:)', 0:255);  % Comptage des fr�quences data_int dans une intervalle 0-255 

freq = freq(:)'/sum(freq);  % Vecteur avec les probabilit�s d�appariations de toutes les fr�quences
indice_lettres = find(freq);  % Suppression des entiers non pr�sents, on stocke les indices des probabilit�s non nuls
freq = freq(indice_lettres); % Les probabilit�s correspondantes aux fr�quences d'appariation

e=0;    % Initialisation de la variable e

% Calcul de l'entropie de la source
for i=1:length(freq)
    e=e+(freq(i)*log2(1/freq(i)));  % Formule de l'entropie, cf cours
end
