local ArtifactsCollector = Class(function(self, inst)
    self.inst = inst
    --用来检测replica还在不在的？
    self._exist_replica_test = net_bool(inst.GUID, "artifactscollector._exist_replica_test", "exist_replica_testdirty")

    inst:ListenForEvent("exist_replica_testdirty", function()
        SendModRPCToServer(GetModRPC("existhealthreplica", "updatehealth"))
    end)

end)

return ArtifactsCollector