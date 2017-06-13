Tạo pool tên new-pool số pg là 16
ceph osd pool create pool-test 16 16
List danh sách pool
ceph osd lspools
Xóa một pool
ceph osd pool delete pool-test pool-test --yes-i-really-really-mean-it
Set số pg và pgp cho Pool, khi set phải set đồng thời cả 2 time số 
ceph osd pool set pool-test pg_num 128
ceph osd pool set pool-test pgp_num 128
Set lại crush rule set cho pool
ceph osd pool set pool-test crush_ruleset 4 
Set số replicate của object trong pool
ceph osd pool set pool-test  size 1

Xem thông tin trạng thái cluster, monitor, osd
ceph -s
Xem thông tin cluster kiểu realtime
ceph -w
Xem danh sách OSDs
ceph osd tree
Xem thông tin chi tiết OSD, IP:Port
ceph osd dump
Xem thông tin chi tiết PG, state, bytes, OSD
ceph pg dump
Xem thông tin về OSD 0, IP:PORT, host
ceph osd find 0
Xem thông tin chi tiết quorum
ceph quorum_status
Xem thông tin chi tiết từng mon
ceph mon_status
Xem thông tin khả năng lưu trữ của rados
rados df
Xem thông tin crush map
ceph osd getcrushmap -o crushmapdump
crushtool -d crushmapdump -o crushmapdump-decompiled
Import lại file crushmap
crushtool -c crushmapdump-decompiled -o crushmapdumpcompiled
ceph osd setcrushmap -i crushmapdumpcompiled
Start OSD disk 
• Ubuntu
sudo start ceph-osd id={osd-num}
• Centos
sudo /etc/init.d/ceph start osd.{osd-num}
List danh sách phân vùng ceph
ceph-disk list





Tạo 1 image  trong pool, mặc định sẽ có 3 object (id, directory, header)
rbd -p pool-test create disk10 --size 1024 [--stripe-unit 65536 --stripe-count 4] --object-size 8M
Xóa 1 image điều kiện: Không có snapshot, không map với client - Delete all data/object
rbd rm pool-test/disk10
List danh sách các image trong pool
rbd ls pool-test
Xem thông tin chi tiết của image trong pool, object cùng prefix sẽ thuộc cùng 1 image
rbd info pool-test/disk10
Disable một số tính năng của image
rbd feature disable pool-test/disk10 fast-diff,object-map,exclusive-lock,deep-flatten
Xem client nào đang mount vào image
rados -p pool-test listwatchers rbd_header.5e3c2ae8944a










List danh sách các object trong pool
rados -p pool-test ls
Xem thông tin từng object trong pool
ceph osd map rbd disk01
osdmap e89 pool 'rbd' (0) object 'disk01' -> pg 0.585ecb69 (0.29) -> up ([0,1], p0) acting ([0,1], p0)
vị trí object /var/lib/ceph/osd/ceph-0/current/0.29_head/
Tạo 1 object và đẩy dữ liệu vào object
rados -p pool-test put new_object test.txt
Xóa 1 object
rados -p pool-test rm new_object




    

Show các map trên con host
rbd showmapped 
Map 1 image lên dev
rbd map --image pool-client/disk01
Unmap device
rbd unmap /dev/rdb0



systemctl restart ceph-mon.target
systemctl restart ceph-osd.target     
systemctl restart ceph-radosgw.target
systemctl restart ceph.target 
systemctl restart ceph-mds.target 
systemctl start ceph-osd@4














Xem thông tin user
radosgw-admin user info --uid=testuser1
List thông tin về region
radosgw-admin region list
Lấy thông tin bản đồ region
radosgw-admin region-map get
Lấy thông tin chi tiết vể region
radosgw-admin region get --rgw-region="default"
List thông tin về zone
radosgw-admin zone list
Lấy thông tin cấu hình của zone
radosgw-admin zone get --rgw-zone="default"
Set thông tin cho zone
radosgw-admin zone set --rgw-zone=hyperlogy --infile hyper.json
Update lại bản đồ
radosgw-admin regionmap update






  256  ceph-deploy purge client
  257  ceph-deploy purgedata client











Centos 7

ceph-deploy install osd4
ceph-deploy --overwrite-conf admin osd4
rbd -p pool-test create disk10 --size 1024
rbd feature disable pool-test/disk10 fast-diff,object-map,exclusive-lock,deep-flatten
rbd map pool-test/disk10
rbd showmapped 
mkfs.xfs /dev/rbd0
mount /dev/rbd0 /mnt
dd if=/dev/zero of=test1 bs=1M count=500

Khi cần umount
rbd showmapped
service rbdmap stop
 rbd unmap /dev/rbd0


rbd rm rbd/myrbd

blockdev --getsize64 /dev/rbd0
Loại này là cho ext4
resize2fs /dev/rbd0

XFS thêm 1 lệnh này nữa mới ăn tiền
xfs_growfs /client1/
Pasted from <http://dachary.org/?p=2179> 


rule ssd-all {
  ruleset 1
  type replicated
# These lines mean ssd-all will be used when the replica 
  # count is between 1 & 5 inclusive
  min_size 1  
  max_size 5
# Take the top level pool named 'ssd'
  step take ssd
# Choose all host nodes.  In my case, there are only 2.
  step choose firstn 0 type host
# Choose up to to 2 leaves of type osd.
  step chooseleaf firstn 2 type osd
  step emit
}


ceph-deploy --overwrite-conf config pull {hostname}

Pasted from <http://docs.ceph.com/docs/jewel/radosgw/config/> 
