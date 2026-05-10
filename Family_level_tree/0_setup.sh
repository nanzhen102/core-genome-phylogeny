#!/bin/bash
# =============================================================================
# Step 0: One-time setup — download and compile pipeline dependencies
# Run once on the LOGIN NODE: bash 0_setup.sh
#
# Dependencies installed:
#   - FastOrtho (compiled from source)
#   - catfasta2phyml.pl (third-party Perl script by Johan Nylander)
# =============================================================================

set -e

INSTALL_DIR="/global/project/hpcg1553/Aspen_Nanzhen_Qiao/MGG"

# --- FastOrtho ---
echo "=== Installing FastOrtho ==="
cd "${INSTALL_DIR}"

if [ -f "FastOrtho/src/FastOrtho" ]; then
    echo "FastOrtho already compiled at ${INSTALL_DIR}/FastOrtho/src/FastOrtho. Skipping."
else
    git clone https://github.com/olsonanl/FastOrtho.git
    cd FastOrtho/src/
    make
    echo "FastOrtho compiled at ${INSTALL_DIR}/FastOrtho/src/FastOrtho"
fi

# --- catfasta2phyml.pl ---
echo ""
echo "=== Installing catfasta2phyml.pl ==="
cd "${INSTALL_DIR}"

if [ -f "catfasta2phyml/catfasta2phyml.pl" ]; then
    echo "catfasta2phyml.pl already exists. Skipping."
else
    git clone https://github.com/nylander/catfasta2phyml.git
    echo "catfasta2phyml.pl available at ${INSTALL_DIR}/catfasta2phyml/catfasta2phyml.pl"
fi

echo ""
echo "=== Setup complete ==="
echo "FastOrtho:        ${INSTALL_DIR}/FastOrtho/src/FastOrtho"
echo "catfasta2phyml:   ${INSTALL_DIR}/catfasta2phyml/catfasta2phyml.pl"
echo ""
echo "Update paths in 4_fastortho.sh and 12_catfasta2phyml.sh if needed."