function [Ta q] =taux_erreur(code_emis,code_recu) %Renvoi le nombre des erreurs q et le taux d'erreur Ta
q=0;
p=size(code_emis);

for i=1:p(1)
    for j=1:p(2) 
        if (code_recu(i,j) ~= code_emis(i,j))
            q=q+1;
        end
        
    end
end 

Ta = (q/(p(1)*p(2)))*100;

end 