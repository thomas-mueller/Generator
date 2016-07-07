#!/bin/bash


# LHE fragment -> LHE
# CMSSW_7_1_16_patch2
# https://cms-pdmv.cern.ch/mcm/requests?produce=%2FGluGluHToTauTau_M125_13TeV_powheg_pythia8%2FRunIIWinter15wmLHE-MCRUN2_71_V1-v1%2FLHE&page=0&shown=127

curl -s --insecure https://cms-pdmv.cern.ch/mcm/public/restapi/requests/get_fragment/HIG-RunIIWinter15wmLHE-00064 --retry 2 --create-dirs -o Configuration/GenProduction/python/HIG-RunIIWinter15wmLHE-00064-fragment.py 
[ -s Configuration/GenProduction/python/HIG-RunIIWinter15wmLHE-00064-fragment.py ] || exit $?;

cmsDriver.py Configuration/GenProduction/python/HIG-RunIIWinter15wmLHE-00064-fragment.py --fileout file:HIG-RunIIWinter15wmLHE-00064_step1.root --mc --eventcontent LHE --datatier LHE --conditions MCRUN2_71_V1::All --step LHE --python_filename HIG-RunIIWinter15wmLHE-00064_1_step1_cfg.py --no_exec --customise Configuration/DataProcessing/Utils.addMonitoring -n 7791

# cmsDriver.py Configuration/GenProduction/python/HIG-RunIIWinter15wmLHE-00064-fragment.py --fileout file:HIG-RunIIWinter15wmLHE-00064_step1.root --mc --eventcontent DQM --datatier DQM --conditions MCRUN2_71_V1::All --step LHE,USER:GeneratorInterface/LHEInterface/wlhe2HepMCConverter_cff.generator,GEN,VALIDATION:genvalid_all  --fileout file:HIG-RunIIWinter15wmLHE-00064_genvalid_step2.root --mc -n 1000 --python_filename HIG-RunIIWinter15wmLHE-00064_genvalid_step2.py --dump_python --no_exec

# cmsDriver.py step2 --filein file:HIG-RunIIWinter15wmLHE-00064_genvalid_step2.root --conditions MCRUN2_71_V1::All --mc -s HARVESTING:genHarvesting --harvesting AtJobEnd --python_filename HIG-RunIIWinter15wmLHE-00064_genvalid_harvesting_step3.py --no_exec


# LHE -> GEN-SIM:
# https://cms-pdmv.cern.ch/mcm/requests?produce=%2FGluGluHToTauTau_M125_13TeV_powheg_pythia8%2FRunIISummer15GS-MCRUN2_71_V1-v1%2FGEN-SIM&page=0&shown=127
# CMSSW_7_1_18

curl  -s https://raw.githubusercontent.com/cms-sw/genproductions/4e1e63e2b7439420b0d88c520a225c96ea31a2ce/python/ThirteenTeV/Higgs/SMHiggsToTauTau_13TeV-powheg_pythia8_cff.py --retry 2 --create-dirs -o  Configuration/GenProduction/python/ThirteenTeV/Higgs/SMHiggsToTauTau_13TeV-powheg_pythia8_cff.py 
[ -s Configuration/GenProduction/python/ThirteenTeV/Higgs/SMHiggsToTauTau_13TeV-powheg_pythia8_cff.py ] || exit $?;

cmsDriver.py Configuration/GenProduction/python/ThirteenTeV/Higgs/SMHiggsToTauTau_13TeV-powheg_pythia8_cff.py --filein file:HIG-RunIIWinter15wmLHE-00064_step1.root --fileout file:HIG-RunIISummer15GS-00055_step4.root --mc --eventcontent LHE --customise SLHCUpgradeSimulations/Configuration/postLS1Customs.customisePostLS1,Configuration/DataProcessing/Utils.addMonitoring --datatier GEN-SIM --conditions MCRUN2_71_V1::All --beamspot Realistic50ns13TeVCollision --step GEN,SIM --magField 38T_PostLS1 --python_filename HIG-RunIISummer15GS-00055_1_step4_cfg.py --no_exec -n 71
