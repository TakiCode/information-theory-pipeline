%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%                                                                     %%
%%       FONCTION DE CONVERSION D'UN ENTIER EN CARACTERE               %%
%%                                                                     %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function texte = int2char(nombre)
for i = 1 : length(nombre)
    % Convertit le 27 en point
    if nombre(i) == 27
        nombre(i) = 46 - 64;
    elseif nombre(i) == 28
        % Convertit 28 en espace
        nombre(i) = 32 - 64;
    elseif nombre(i) == 29
        % Convertit la virgule en 29
        nombre(i) = 44 - 64;

    end
end
texte = char(nombre + 64);