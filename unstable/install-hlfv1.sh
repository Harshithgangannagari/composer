(cat > composer.sh; chmod +x composer.sh; exec bash composer.sh)
#!/bin/bash
set -ev

# Get the current directory.
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Get the full path to this script.
SOURCE="${DIR}/composer.sh"

# Create a work directory for extracting files into.
WORKDIR="$(pwd)/composer-data"
rm -rf "${WORKDIR}" && mkdir -p "${WORKDIR}"
cd "${WORKDIR}"

# Find the PAYLOAD: marker in this script.
PAYLOAD_LINE=$(grep -a -n '^PAYLOAD:$' "${SOURCE}" | cut -d ':' -f 1)
echo PAYLOAD_LINE=${PAYLOAD_LINE}

# Find and extract the payload in this script.
PAYLOAD_START=$((PAYLOAD_LINE + 1))
echo PAYLOAD_START=${PAYLOAD_START}
tail -n +${PAYLOAD_START} "${SOURCE}" | tar -xzf -

# Pull the latest Docker images from Docker Hub.
docker-compose pull
docker pull hyperledger/fabric-ccenv:x86_64-1.0.0-alpha

# Kill and remove any running Docker containers.
docker-compose -p composer kill
docker-compose -p composer down --remove-orphans

# Kill any other Docker containers.
docker ps -aq | xargs docker rm -f

# Start all Docker containers.
docker-compose -p composer up -d

# Wait for the Docker containers to start and initialize.
sleep 10

# Create the channel on peer0.
docker exec peer0 peer channel create -o orderer0:7050 -c mychannel -f /etc/hyperledger/configtx/mychannel.tx

# Join peer0 to the channel.
docker exec peer0 peer channel join -b mychannel.block

# Fetch the channel block on peer1.
docker exec peer1 peer channel fetch -o orderer0:7050 -c mychannel

# Join peer1 to the channel.
docker exec peer1 peer channel join -b mychannel.block

# Open the playground in a web browser.
case "$(uname)" in 
"Darwin") open http://localhost:8080
          ;;
"Linux")  if [ -n "$BROWSER" ] ; then
	       	        $BROWSER http://localhost:8080
	        elif    which xdg-open > /dev/null ; then
	                xdg-open http://localhost:8080
          elif  	which gnome-open > /dev/null ; then
	                gnome-open http://localhost:8080
          #elif other types blah blah
	        else   
    	            echo "Could not detect web browser to use - please launch Composer Playground URL using your chosen browser ie: <browser executable name> http://localhost:8080 or set your BROWSER variable to the browser launcher in your PATH"
	        fi
          ;;
*)        echo "Playground not launched - this OS is currently not supported "
          ;;
esac

# Exit; this is required as the payload immediately follows.
exit 0
PAYLOAD:
�  �$Y �]Y��ʶ���
��o��q�IQAAD�ƍ
fgT�_@k�������;����L�$W�)]�t�C����hLC��/������$��z��P-@�h��1��F~�p�b�n�V�k�ػi�z�����p��?������jz�7�h�~ʊ���M���[��-Ae!\L!p��x7����%	�����wo{�{�j���Z�9�%���C�����p9�ɢyE�p_��ۉVag���=
S�AwG�g�\�cO�R��\�w�h<OpG�$�6?k�V�����4B�����yNٔK�(M�(M�Iظ�E����OS$����Q����O�7�W��
?G�?�?E�*�q}*���s�_5��	����UNl�jM�>��t��Xk�֩R�.4Q�e$ڧ���$X`�+X�\v�&�m�0R�?�D�_7�
�B ��@���c��6�'pG���&zHPt�C��I�@O�<a��t�����24H���֮ޗG�.��P��-Q�j�u��w�4XQ^{�z�S����r�r�d�s��r��¨j��|��*���ױ�|t�7�?J��s�O ��/��?/�,�|.6o%�,�M���A&s �5e%����!ǳ�Jܵ���\�'�Y��i�q����k�`jZC�Z��(J~#�D�S�&��p�s�dl�P�S�W�&meq|��!9�G��9����'��6̅;g㣸��B��b�Mn1�z���+1�C�Aɔ�z�ŌF�!�e�A=ޗe� v0?�`����#Сsϡ��Չ�X,�����^�����53��rw)m-lq�0�~T�����L�N�"��$̓��V���Nip����xR���M�B"N�UqI(m����|?�Ȅ�1Ӱ��X�1j��>����f+�d�r�n���,7GQ�;S��kQ�ё�@��	����&$�g�w��f?�y4�P/^�[jx⹱� �����H��eQV���I8h�71��o�L��V�Q��@���Vc$J�Ms�<2rR� 	�"xY�����\��$�H�+qc6K��9����oY���[M���F��UW2i1��H�E#�3�^4MG�.����lx���i�,�$��i���������$�?)n������C	���e�-�/�r��,�����#ì�ޫ��>��$��-����)�I�B?Ҩ�(T�G��
���!{��� �WS���r��̽/S$y�A�|� �Pt%�ĳ	#�Y,X�}<^�g��(��I�T�3԰�D��Zg��.�����Їa����"�31��������( ͽ���K����2��]�թ� ��TuhM�����)�zKӔ�FN���U {��y����:�q������xH�8�t�=܇�.���|K3ymJ
�(�Hs=_4���Lrآ��F>�>��6s4!��7�8��D���͛X�����P���o�m��D����0��Z<��h�Y�!���&��x}��$�]���C���d�Q
>��?s������P��?���zT���W���k���wL���?��J���_��W��T�_)�����_�ҧ� 'Q���f�������); 	h�e0�u(��%�\��GzU��?�2�������� +��\�÷{��0�hR���z��J;�%���# �����2?_�������V0#&�7M��1��[��a=���z�K�9��n��ndA0���m��5�����
���H�߮d{V�?�/��W��T��������?X%��@��W��U���߇��W��T��|���J�O�������L��o�P�R�>BaJo�q�����>Y���CŰ��ð��gb64���������*��< }d�ex��'��T�[ӹg�6|�=̝�jI:FwM�f�ә���[֛ɼa�]c��4%
��<�t��ʝ��V�g��I�kL���B�r6("�
���@v���,�A�����8�@r��%�i�V��ڙN�m>|��5Y���.,����μ����´g�M��@�$0����;����C��<,��$d�ݦ��v�uV�LiYZw4�C^nvL5QBڱ�����Y���$d��9��������W�����/�B������)��������?�x��w�� �\��Z��Rp	��P��b�_���)����+������!������ U�_�D�{�M:x�������Юoh�a8�zn��(°J",�8, �Ϣ4K��]E��~(�����!Eue�����T&��z�V��͉�1]0��cϑ��f?j�cO^�«�(���0�:uZI��!���n٫l�a�' ��]f��S��n���u{b� i�l0heC���<�甒Q������0���x~��)�/��Q������;��P��,���������B�߾�L(\N��+�/����ۗ����O�8Vѿ|&�_;z1���tu����?��<�IW�?e�K���:w�Y�X�ql�t�b)��(�s	��l<!p�u<�Y�	ǷY���j��4�A���p���T��|=.���"�?>�%�a��bL��vK����W���i�~�yu�g=�	^�뺻�V��KP=�#r�ec&�:�L��R>j��[>#~"�m��G��ZOE\TG��A�ك��W�?�g��k�A?`�T�������CI��G��+����E�����h�
e���a���<���}���+o����/����9k9
�V�% �<4���ǳ���,	���c�yx��21����ܥ�p���K��<��Ih�.�G�@C���~<���ā�ɧ9{����<��ж�1���t�o�0�b�"F�E7����#�1<�cj2��:�޼9��LMu���;q�\Q|o6h�*��Q�z���"��F��������s���X�q�%��p�wk�ʹ���hMX���UjS����ʝJ���9�Za��5�� �RgD��ޖK�d�w��n�5���`��Ԝ��}]q��B[K�u��8�8g��vv���" ��P�8�+��t���I4�[�3ۧ�+k]ׇ��9^(i��Ń}���8�����R�[����W������P[��%ʠ������JV��K�������� ����ͽdv�
9��/�,?��ǽ��O^ʏ|�o �y�9��s �Gܖ�^��}74��r�?�=J�ɱ�&�t��*�{��3i/�eZ�o�JOM���G|k�r�F��0�S錉S��u��(�F"��j�ո�V>�yB���8��Х��Ss �5�͑�K��n��]z�M��Z��F��K]��O�L;|�՞ق%w��F�o�~:8�F�&���-T�Cr�z�ϳ���3��k� .������J�oa��/�?��?%�+��������d��������zT������_���S�(���?�a��?�����uw��Ǩ�_������+������b���^��T��V
.���G�4�a(�R�C�,�2��`���h��.��>J8d��T��>B�.�8�WY`~+�A�7��ɯ��W.8���)�r|<�̩�f�/0DhN=�v�t���R[��ɫ���rNGm�`]	ot�݋7�#`����;VnDI�1��w����'0�o�d=�(G��`(���:�b��U�>
/r�~���2�R���\|�=~��h����(Z��W)��I�K�o����!(������oP���Hq�զK;���&��O����N2u�\�۞�n(�
�F��+{O��g��n�D���ڜ;�ծj�t����M����a��?������>G�&}��?4Bߊ?�9��wi��o�tR�rk?�V�wS��K��݊`��ko��Y>����sGs�pY?��9�v��N,�����ߵ+�4�h�]�����$�۷�>��|�6�t�'7+{��
׾�����
�+�y��7��m���VWD]�o�*�sӑ���A��~�;r}��j��ڗ��h4�����o5���V�y�6{x�EQ�׷�r�,r9��`�<�(��,|�?��y�� �/G�L�;����N�&��#��j/���hy�IsE��n�ŽyX��.8�}=r������7��5x���?�ʾ���yɱEˇ��@.j�=n����fQ2���o�|��Q���(�78M\8�n&[�:Y?`�'T��j��I�\"� D~$�b�%k�-�'�>�;���|�"�۞�����T��l(�\$��.��M �|Wođ�ѐ�;0����*���d�?-6��g�^WV����t���I�n�����v�-���1��>��u�����=�ʻ���Ӌ3O�����)��E�C�����]m��d���rx.\%�� �1����뺗�u�麭{ߔ\{���֭=�މ	jBL0�%h�$h�����~R�4��H���#
1Q?�m��lg�9;����M�����ҧ��������<D2A�")<]F;�Y#�L&���LG�a\��e혀��I��,/L��p:�ǭ��7�r`��ѱ��b 6t/��5 h��s�3�ۄ�J�ńq!v�E�Q�%I������v��k�&��u#��
�k�Cn��4�0�Rt�kq���3V3EL<�d�v[�t�ԵQ�w����|x�Y����P�����&3ّ鶐-$��[�'�%��*|��H�w�w�8g܄�e���_3�\We�ДF�#!2�R��8�.�F�j�5�w���Bi1^2f^�[��[7gyQc4E��)��F�E�E�e�6��Q�ti&Nm8=�����_�S�;��ɉ����4�b|�\]������iU��=�s�g�w�yN��S�9�uPK�!ˠ�Hҩ��#U��q���YG�S���=�Re�EXs�7#�ˈ�H���׌�����|t�D��8��U���.s�fGW���u�q�]d��SyV��R�6y����U�.r�\�lQ�I�Z;[3o u��j����g��d&/G��O�����g�uT�h��*�7V�x�s.���=��k�n���4m&?�t눅��8/��f��8��ˈ	���91�{�*���v.����7��Z��|WW�%�Ѕ����÷9Z���������3w��T��WU�1�p�i�捣�����#`>��&�m�߭:����F��f��������w?�W��!PX;�qj��?���Z*q�m����<�j�x86�"�^�_��Q7��ey4�z=۾jե�
���x8?�y8��3zx�N�;t���kw���?\��Z�|��C�)~���]z�ϟ�^��3حt�	
��\3�C?tB��	�n\z�΍�W�Ϝ��}z�����<���M���M�{��Ma��H֧�y����#rދ�\��r=����F/aL�5�	���xa��B�`h��o3�QX��7, �|��6rDr3o��X��;��%����������2\��4�S�{��Ks�|���z�&��a�2�|=8���fn1/$>g�ۜl�,�I"�6:��s���*�a����t��v����d��"Y��no͢ʤ����il����LH���V��{�o��\�r��bB�3p)(��BB�*��L�l>��^JM)p�뭗B���~�>��S6�f��L�U����"�v�@Xj_�Om�#���'8$�f����bX{j���[�[��kJ6�ƃ��VqW<�$��6�.s������(�(Dsy��V�'�ܑPR̄�l��'$ q8d%�a�I#�r
fZp$B�H��Z>�!���1��9d�;�M����V!�Jj���v�V,�#�?�4Y��y�ZJ�Q�\����a�����`��N��\��w�C>?�D��F��W��1)˒Xg�e˝��u�@�Kq��R2��D���L~( �j�@�~�kE��`�n�H�_	��X1��T��D[i�"T�����MNYpF��ZQ�"t�����i��3-)5�,{�gd�*KT��!_���}C�к|�nX9��0vu"Q9�	Ǜ��#����bλU�~p	�T2R�#�&S��
դ�K�}�����*Kl���(Ke���,Q4��
��*\%I��B����Bg�5s����4Ϸ��P�jW�Eyk'�N+�*op;�;�Ĥ� r�}8e	�ɚDp/��2Hz#LʕΔ9�S�=�3�K��	m�ޡ�{[�Z��BI`�7�ҽ��� XB�y�	7�C��[ �ِ���kM�kR��)�=C1�M�l9�nO��i0�)����l����V��6N�F�Os����Zk�}:�v%��A���'֮�8]7�*me��tr買O�Y��L�Y�r��4�VU��]� ��D#�.w�Ѝ�5�j����,���B���A)Y�q�&�Fp�q���%itr�Np1�)�y���̯�6U���~�oi-;Pxh:Nj�$["Np�ٚLm�C7C�����?��}�a�u�N�s�Bg֮�����	K��!hP �T��-�n��ׅ���TyV�Y2��2�������4�(z_�*|�<�2dV�H?�<���-N�U��9�� ���H�����1����!��8�������m}�<���~)X�������Ik�A�EJ=S�b� ȷ��-�Vvn�A���ԑiK�E��Ѡa.:J�p�����,88q4�Q��
���t��"�{����H��p�CS�R�R�_$����(X��]�	�#�--���V����� �y�DP��#[L)��u�6Y��W�Ջ�`��=�*�F�`�@P��)0ZLP��	
i�?���4n�=jb8D,K�$S��CD��x&:����z+1�h��#�F��`�/���;��"]��+CoKAEg���8W�^�|�|cs�hC���T/&[��ER��GP]�6�� LR��r8+70}\�i�^:�����6�8l�8��u�zIwC��N�-S��i�;&�9&>ӊ9˳��C�u*���i+î�;��zX���������}Y<,;������:�d��#l��$�rW�$�c^v��)�����,fPy���8V��3A�IL5(2iE��5eY���0�pyg0aԦ��Ĕ�CdP#����Ʃ-W a�;J��)1-�(L ��%�FH�ܞ.��ax0���p���*&����`��X8l0d7B��yd�]"5����Q�wP��䐨+Q��W���y���bYl�#�����^)U���,���e��F�0�"teK.��w��aMLlI8�st�%y�\/�"�N7��j�)컴���m�q��ǡ��l�o%��}h�l&�
���Br+��6.�[Ͱ]�m�QVk-!�V;\����µ���)��qD�TT^�xM���3|^K�<X�K��߂؄ h��Dq��w���z��8��$�y��N@WXn�E`1�^}�on�^�����^z������������5�aͮ�=|��nv�M'�s�?Q���?|��yYpn8�}�?y�������Ѝ�����7o��O~5���OBߋ����;q���]i��گL���6����*�t������Ǟ�b�w�͟qz�5��o~�zz��Q�)�OS���Л���Wmj�M����6M��	��N�+���+����6�Ӧv��N�g�}�����|����pR�*4P?8K��Y.h�m�t�"B�$�1C�-�z���IC��C���y�)j��3��:�g`J�?��<�8l�x�xG�H�5p9������4�e��=gƎ��sf�i�� {Όm�q\�93G��{�)0�cf΅��"��*m��%�#����V��+F��d';��N���_�C$  