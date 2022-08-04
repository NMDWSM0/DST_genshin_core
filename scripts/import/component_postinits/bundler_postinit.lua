AddComponentPostInit("bundler", function(self)
    function self:OnFinishBundling()
        if self.bundlinginst ~= nil and
            self.bundlinginst.components.container ~= nil and
            not self.bundlinginst.components.container:IsEmpty() and
            self.wrappedprefab ~= nil then
            local wrapped = SpawnPrefab(self.wrappedprefab, self.wrappedskinname, self.wrappedskin_id)
            if wrapped ~= nil then
                if wrapped.components.unwrappable ~= nil then
                    local items = {}
                    for i = 1, self.bundlinginst.components.container:GetNumSlots() do
                        local item = self.bundlinginst.components.container:GetItemInSlot(i)
                        if item ~= nil then
                            table.insert(items, item)
                        end
                    end
                    wrapped.components.unwrappable:WrapItems(items, self.inst)
                    self.bundlinginst:Remove()
                    self.bundlinginst = nil
                    self.itemprefab = nil
                    self.wrappedprefab = nil
                    self.wrappedskinname = nil
                    self.wrappedskin_id = nil
                    if self.inst.components.inventory ~= nil then
                        self.inst.components.inventory:GiveItem(wrapped, nil, self.inst:GetPosition())
                    else
                        DropItem(self.inst, wrapped)
                    end
                ----
                --else
                elseif wrapped.prefab == "artifactsbundle" then
                    self.bundlinginst:Remove()
                    self.bundlinginst = nil
                    self.itemprefab = nil
                    self.wrappedprefab = nil
                    self.wrappedskinname = nil
                    self.wrappedskin_id = nil
                    if self.inst.components.inventory ~= nil then
                        self.inst.components.inventory:GiveItem(wrapped, nil, self.inst:GetPosition())
                    else
                        DropItem(self.inst, wrapped)
                    end
                ----
                else
                    wrapped:Remove()
                end
            end
        end
    end
end)