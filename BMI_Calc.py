#!/usr/bin/env python
# coding: utf-8

# BMI CALCULATOR

# In[1]:


name= input("Enter your name: ")
weight=int(input("Enter your weight in pounds: "))
height=int(input("Enter your height in inches: "))

BMI= (weight*703)/(height*height)
print("BMI:", BMI)
if BMI >0:
    if (BMI<18.5):
        print(name+",you are Underweight")
    elif (BMI>18.5 and BMI<=24.9):
        print(name+",you are at Normal Weight")
    elif (BMI<=29.9):
        print(name+",you are Overweight")
    elif (BMI<=34.9):
        print(name+",you are Obese")
    elif (BMI<=39.9):
        print(name+",you are Severely Obese")
    elif (BMI>40):
        print(name+",you are Morbidly Obese")
    else:
        print("Enter valid inputs")


# In[3]:





# In[ ]:




