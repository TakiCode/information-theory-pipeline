%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%                          FONCTION ENTROPIE                            %%
%%%%%%%%%%%%%%%%%%%%%%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Cette fonction calcule les frequences d'apparition des 
% symboles dans une source de message
% Elle calcule ensuite l'entropie de la source
 
function e = entropie(d)
 
% Conversion des données en entiers non signes (0 à 255)
data_int = uint8(d);
 
% Calcul des frequences d'apparition des lettres dans la phrase

freq = histc(data_int(:)', 0:255);  % Comptage des fréquences data_int dans une intervalle 0-255 

freq = freq(:)'/sum(freq);  % Vecteur avec les probabilités d’appariations de toutes les fréquences
indice_lettres = find(freq);  % Suppression des entiers non présents, on stocke les indices des probabilités non nuls
freq = freq(indice_lettres); % Les probabilités correspondantes aux fréquences d'appariation

e=0;    % Initialisation de la variable e

% Calcul de l'entropie de la source
for i=1:length(freq)
    e=e+(freq(i)*log2(1/freq(i)));  % Formule de l'entropie, cf cours
end
