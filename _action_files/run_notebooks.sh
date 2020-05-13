set -e
cd $(dirname "$0")/..
cd _notebooks/

ERRORS=""

for file in *.ipynb
do
    if [ "${file}" = "2020-02-20-test.ipynb" ]; then
        echo "Skipping ${file}"
    elif papermill --kernel python3 "${file}" "${file}"; then
        echo "Sucessfully refreshed ${file}\n\n\n\n"
    else
        echo "ERROR Refreshing ${file}"
        ERRORS="${ERRORS}, ${file}"
    fi
done

# Emit Errors If Exists So Downstream Task Can Open An Issue
if [ -z "$ERRORS" ]
then
    echo "::set-output name=error_bool::false"
else
    echo "These files failed to update properly: ${ERRORS}"
    echo "::set-output name=error_bool::true"
    echo "::set-output name=error_str::${ERRORS}"
fi