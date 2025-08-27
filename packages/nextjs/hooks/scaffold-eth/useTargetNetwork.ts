import { useEffect, useMemo } from "react";
import scaffoldConfig from "~~/scaffold.config";
import { useGlobalState } from "~~/services/store/store";
import { ChainWithAttributes } from "~~/utils/scaffold-eth";
import { NETWORKS_EXTRA_DATA } from "~~/utils/scaffold-eth";

/**
 * Returns the Mandala Chain from scaffold config as the target network.
 * This uses the predefined Mandala chain configuration instead of wallet detection.
 */
export function useTargetNetwork(): { targetNetwork: ChainWithAttributes } {
  const targetNetwork = useGlobalState(({ targetNetwork }) => targetNetwork);
  const setTargetNetwork = useGlobalState(({ setTargetNetwork }) => setTargetNetwork);

  const mandalaChain = scaffoldConfig.targetNetworks[0];

  useEffect(() => {
    console.log("useTargetNetwork - Effect triggered");
    console.log("Current targetNetwork:", targetNetwork);
    console.log("Mandala chain config:", mandalaChain);

    try {
      // Always set to Mandala Chain on mount if not already set
      if (!targetNetwork || targetNetwork.id !== mandalaChain.id) {
        console.log("Setting target network to Mandala chain");
        const mandalaWithExtraData = {
          ...mandalaChain,
          ...NETWORKS_EXTRA_DATA[mandalaChain.id], // Include any extra data if defined for chain ID 4818
        };
        console.log("Network with extra data:", mandalaWithExtraData);
        setTargetNetwork(mandalaWithExtraData);
      } else {
        console.log("Target network already set correctly");
      }
    } catch (error) {
      console.error("Error setting target network:", error);
      console.log("Mandala chain config:", mandalaChain);
      console.log("Current target network:", targetNetwork);
    }
  }, [targetNetwork, setTargetNetwork, mandalaChain]);

  return useMemo(
    () => ({
      targetNetwork: targetNetwork || mandalaChain,
    }),
    [targetNetwork, mandalaChain],
  );
}
