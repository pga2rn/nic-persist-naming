
include $(TOPDIR)/rules.mk

PKG_NAME:=nic-persist-naming
PKG_VERSION:=2021-01-25
PKG_RELEASE=1.3

include $(INCLUDE_DIR)/package.mk

define Package/nic-persist-naming
  TITLE:=nic-persist-naming
  DEPENDS+= +ip
endef

define Build/Prepare
	mkdir -p $(PKG_BUILD_DIR)
	$(CP) ./* $(PKG_BUILD_DIR)/
endef

define Build/Compile
endef

define Package/nic-persist-naming/install
	$(INSTALL_DIR) $(1)/etc/init.d
	$(INSTALL_BIN) ./files/renameif.init.d $(1)/etc/init.d/renameif
	$(INSTALL_DIR) $(1)/etc/hotplug.d/net
	$(CP) ./files/90-Predictable_interface_naming.hotplug \
		$(1)/etc/hotplug.d/net/90-Predictable_interface_naming
	$(INSTALL_DIR) $(1)/usr/bin
	$(INSTALL_BIN) ./files/renameif.sh $(1)/usr/bin/renameif.sh
	$(INSTALL_BIN) ./files/genifname.sh $(1)/usr/bin/genifname.sh
endef

$(eval $(call BuildPackage,nic-persist-naming))
