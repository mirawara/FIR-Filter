from fxpmath import Fxp
index=0
RealCoef=[0.0135,0.0785,0.2409,0.3344,0.2409,0.0785,0.0135]
Coef=[]
print("Coefficienti: \n")
for i in RealCoef:
    print("Coefficiente " + str(index))
    x = Fxp(i, signed=True, n_word=16, n_frac=15)
    print(x)         # float value
    print(x.bin())   # binary representation
    print(x.val)
    Coef.append(x.val)
    index=index+1
print("-----------------------------------------------")
print("Valori del testbench")
TestVal=[1,2,3,4,5,6,7,-1,-2,-3]
for i in TestVal:
    print("Numero: ")
    x = Fxp(i, signed=True, n_word=16, n_frac=7)
    print(x)         # float value
    print(x.bin())   # binary representation
    print(x.val)
    print("\n")
    index=index+1
print("-----------------------------------------------")
print("Risulati se in input ho tutti 1")
p=pow(2,7)*Coef[0] +pow(2,7)*Coef[1] +pow(2,7)*Coef[2] +pow(2,7)*Coef[3] +pow(2,7)*Coef[4] +pow(2,7)*Coef[5] +pow(2,7)*Coef[6] 
print("Valore completo:",end=" ")
print(p*pow(2,-22))
x=Fxp(p, signed=True, n_word=32, n_frac=0)
x=str(x.bin())[:16] #truncation
print("Binary output:",end=" ")
print(x)
print("integer output:",end=" ")
print(int(x,2)*pow(2,-6))
print("-----------------------------------------------")
print("Risulati se in input ho 1,2,3,4,5,6,7")
X=[7*pow(2,7)*Coef[0] +6*pow(2,7)*Coef[1] +5*pow(2,7)*Coef[2] +4*pow(2,7)*Coef[3] +3*pow(2,7)*Coef[4] +2*pow(2,7)*Coef[5] +1*pow(2,7)*Coef[6] ,
7*pow(2,7)*Coef[0] +7*pow(2,7)*Coef[1] +6*pow(2,7)*Coef[2] +5*pow(2,7)*Coef[3] +4*pow(2,7)*Coef[4] +3*pow(2,7)*Coef[5] +2*pow(2,7)*Coef[6] ,
7*pow(2,7)*Coef[0] +7*pow(2,7)*Coef[1] +7*pow(2,7)*Coef[2] +6*pow(2,7)*Coef[3] +5*pow(2,7)*Coef[4] +4*pow(2,7)*Coef[5] +3*pow(2,7)*Coef[6] ,
7*pow(2,7)*Coef[0] +7*pow(2,7)*Coef[1] +7*pow(2,7)*Coef[2] +7*pow(2,7)*Coef[3] +6*pow(2,7)*Coef[4] +5*pow(2,7)*Coef[5] +4*pow(2,7)*Coef[6] ,
7*pow(2,7)*Coef[0] +7*pow(2,7)*Coef[1] +7*pow(2,7)*Coef[2] +7*pow(2,7)*Coef[3] +7*pow(2,7)*Coef[4] +6*pow(2,7)*Coef[5] +5*pow(2,7)*Coef[6] ,
7*pow(2,7)*Coef[0] +7*pow(2,7)*Coef[1] +7*pow(2,7)*Coef[2] +7*pow(2,7)*Coef[3] +7*pow(2,7)*Coef[4] +7*pow(2,7)*Coef[5] +6*pow(2,7)*Coef[6] ,
7*pow(2,7)*Coef[0] +7*pow(2,7)*Coef[1] +7*pow(2,7)*Coef[2] +7*pow(2,7)*Coef[3] +7*pow(2,7)*Coef[4] +7*pow(2,7)*Coef[5] +7*pow(2,7)*Coef[6] ]
index=0
for i in X:
    print(str(index)+")")
    print("Valore completo:",end="" )
    print(i*pow(2,-22))
    x = Fxp(i, signed=True, n_word=32, n_frac=0)
    x=str(x.bin())[:16] #truncation
    print("Binary output:",end=" ")
    print(x)
    print("integer output:",end=" ")
    print(int(x,2)*pow(2,-6))
    index=index+1
    print("\n")
print("-----------------------------------------------")
print("Risulati se in input ho tutti -1")
p=-pow(2,7)*Coef[0] -pow(2,7)*Coef[1] -pow(2,7)*Coef[2] -pow(2,7)*Coef[3] -pow(2,7)*Coef[4] -pow(2,7)*Coef[5] -pow(2,7)*Coef[6] 
print("Valore completo:",end=" ")
print(p*pow(2,-22))
x=Fxp(p, signed=True, n_word=32, n_frac=0)
x=str(x.bin())[:16] #truncation
print("Binary output:",end=" ")
print(x)
print("-----------------------------------------------")
print("Risulati se in input ho tutti -2")
p=-2*pow(2,7)*Coef[0] -2*pow(2,7)*Coef[1] -2*pow(2,7)*Coef[2] -2*pow(2,7)*Coef[3] -2*pow(2,7)*Coef[4] -2*pow(2,7)*Coef[5] -2*pow(2,7)*Coef[6] 
print("Valore completo:",end=" ")
print(p*pow(2,-22))
x=Fxp(p, signed=True, n_word=32, n_frac=0)
x=str(x.bin())[:16] #truncation
print("Binary output:",end=" ")
print(x)
print("-----------------------------------------------")
print("Risulati se in input ho tutti -2,-3,-2,-3,...")
X=[-2*pow(2,7)* Coef[0] -3* pow(2,7)*Coef[1] -2*pow(2,7)* Coef[2] -3* pow(2,7)*Coef[3] -2* pow(2,7)*Coef[4] -3*2^6* pow(2,7)*Coef[5] -2*pow(2,7)* Coef[6] 
,-2*pow(2,7)* Coef[0] -2*pow(2,7)* Coef[1] -3*pow(2,7)* Coef[2] -2*pow(2,7)* Coef[3] -3*pow(2,7)* Coef[4] -2*pow(2,7)* Coef[5] -3* pow(2,7)*Coef[6] 
,-2*pow(2,7)* Coef[0] -2*pow(2,7)* Coef[1] -2*pow(2,7)* Coef[2] -3*pow(2,7)* Coef[3] -2*pow(2,7)* Coef[4] -3*pow(2,7)* Coef[5] -2*pow(2,7)* Coef[6] 
,-2*pow(2,7)* Coef[0] -2*pow(2,7)* Coef[1] -2*pow(2,7)* Coef[2] -2* pow(2,7)*Coef[3] -3*pow(2,7)* Coef[4] -2* pow(2,7)*Coef[5] -3*pow(2,7)* Coef[6] 
,-2* pow(2,7)*Coef[0] -2*pow(2,7)* Coef[1] -2*pow(2,7)* Coef[2] -2*pow(2,7)* Coef[3] -2* pow(2,7)*Coef[4] -3*pow(2,7)* Coef[5] -2*pow(2,7)* Coef[6] 
,-2* pow(2,7)*Coef[0] -2* pow(2,7)*Coef[1] -2*pow(2,7)* Coef[2] -2*pow(2,7)* Coef[3] -2* pow(2,7)*Coef[4] -2*pow(2,7)* Coef[5] -3*pow(2,7)* Coef[6] 
,-2* pow(2,7)*Coef[0] -2*pow(2,7)* Coef[1] -2* pow(2,7)*Coef[2] -2* pow(2,7)*Coef[3] -2* pow(2,7)*Coef[4] -2*pow(2,7)* Coef[5] -2*pow(2,7)*Coef[6] ]
index=0
for i in X:
    print(str(index)+")")
    print("Valore completo:",end="" )
    print(i*pow(2,-22))
    x = Fxp(i, signed=True, n_word=32, n_frac=0)
    x=str(x.bin())[:16] #truncation
    print("Binary output:",end=" ")
    print(x)
    index=index+1
    print("\n")
print("-----------------------------------------------")
print("Risulati se in input ho tutti 32767")
p=32767*Coef[0] +32767*Coef[1] +32767*Coef[2] +32767*Coef[3] +32767*Coef[4] +32767*Coef[5] +32767*Coef[6] 
print("Valore completo:",end=" ")
print(p*pow(2,-22))
x=Fxp(p, signed=True, n_word=32, n_frac=0)
x=str(x.bin())[:16] #truncation
print("Binary output:",end=" ")
print(x)
print("integer output:",end=" ")
print(int(x,2)*pow(2,-6))





     