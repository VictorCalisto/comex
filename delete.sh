#!/bin/sh

# Apagar essa isso na mao da muito trabalho...

kubectl delete storageclass --all
kubectl delete statefulset --all
kubectl delete service --all
kubectl delete configmap --all
kubectl delete deployment --all
kubectl delete pv --all
kubectl delete pvc --all
