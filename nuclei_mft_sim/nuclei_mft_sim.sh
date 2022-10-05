# make sure O2DPG + O2 is loaded
export O2DPG_ROOT=/home/spolitan/alice/O2DPG

[ ! "${O2DPG_ROOT}" ] && echo "Error: This needs O2DPG loaded" && exit 1
[ ! "${O2_ROOT}" ] && echo "Error: This needs O2 loaded" && exit 1

# ----------- LOAD UTILITY FUNCTIONS --------------------------
. ${O2_ROOT}/share/scripts/jobutils.sh

# ----------- START ACTUAL JOB  -----------------------------

NWORKERS=${NWORKERS:-32}
MODULES="--skipModules ZDC"
SIMENGINE=${SIMENGINE:-TGeant4}
NSIGEVENTS=${NSIGEVENTS:-600}
NTIMEFRAMES=${NTIMEFRAMES:-40}
INTRATE=${INTRATE:-50000}
SYSTEM=${SYSTEM:-pp}
ENERGY=${ENERGY:-13500}
[[ ${SPLITID} != "" ]] && SEED="-seed ${SPLITID}" || SEED=""

# create workflow
${O2DPG_ROOT}/MC/bin/o2dpg_sim_workflow.py -eCM ${ENERGY} -col ${SYSTEM} -gen external -j ${NWORKERS} -ns ${NSIGEVENTS} -tf ${NTIMEFRAMES} -confKey "Diamond.width[2]=6." -e ${SIMENGINE} ${SEED} -mod "--skipModules ZDC" \
        -ini ${O2DPG_ROOT}/MC/config/PWGLF/ini/GeneratorLFHypertriton${SYSTEM}.ini -field -5

# run workflow
${O2DPG_ROOT}/MC/bin/o2_dpg_workflow_runner.py -f workflow.json -tt aod --cpu-limit 64