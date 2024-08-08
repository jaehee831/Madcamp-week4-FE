
![-1](https://github.com/user-attachments/assets/9ee68c9e-bc34-46f0-81e7-eaeace8d3cdd)

> **알바천국, 알바몬…** 모두 알바를 구하는 대학생들이라면 한 번쯤 들어봤을, 익숙한 이름들!
하지만 알바를 시작하고 나면, 어떤 플랫폼을 쓰나요?

가게마다 단체 카톡방에 의존하는 알바생 투두리스트, 인수인계, 사장님 공지사항 등등…

불편하고 놓치기도 쉬운 기존의 공지 시스템을 한 번에 바꿔줄, 

**알바계의 커뮤니티 플랫폼! 알바계의 Slack!** 

### **🫠GigHub**를 소개합니다!

<h1>GigHub</h1>

<div style="display: flex; align-items: center;">
    <img src="https://github.com/user-attachments/assets/c11cbe78-0d0f-417d-aa8e-04ad17a7dc1c" alt="0" style="width: 50%; margin-right: 20px;">
    <div>
        <p>일용직 노동자를 뜻하는 🧑‍🏭<strong>Gig worker</strong>,</p>
        <p>이들이 모인 🌐<strong>Hub</strong></p>
        <p>➡️ <strong>GigHub</strong> 입니다!</p>
        <p>(깃헙 아닙니다^.^)</p>
    </div>
</div>

# Team

[이은영](https://www.notion.so/5cf4e727bfd04552b42a52f7c693c1f9?pvs=21)

KAIST 22학번 

Frontend

https://github.com/eunyoung-1118

[이재희](https://www.notion.so/99f32f67a3034ca0a54374ec8de599a7?pvs=21)

GIST 21학번

Backend

https://github.com/jaehee831

# 기능

## 🫠 스플래시/로그인

<div style="display: flex; flex-wrap: wrap;">
    <div style="flex: 1; min-width: 200px; margin: 10px;">
        <img src="https://github.com/user-attachments/assets/a5fa0b73-c38e-40f4-8c0a-3dd110aec975" alt="1" style="width: 100%;">
    </div>
    <div style="flex: 1; min-width: 200px; margin: 10px;">
        <img src="https://github.com/user-attachments/assets/dc2d4f05-e6e5-43e6-bc57-0c424d0d2dbb" alt="2" style="width: 100%;">
    </div>
</div>

<p>- 카카오 로그인 api를 이용해 카카오계정 로그인을 구현했습니다.</p>
<p>- 유저는 <strong>점주</strong>와 <strong>알바</strong>로 포지션이 구분됩니다.</p>
<p> - <code>user</code> 테이블의 <code>isadmin</code> 컬럼이 1이면 점주로 구분됩니다.</p>

<div style="display: flex; flex-wrap: wrap;">
    <div style="flex: 1; min-width: 200px; margin: 10px;">
        <img src="https://github.com/user-attachments/assets/c0949a97-2f3a-401a-a810-1d938626f958" alt="3" style="width: 100%;">
    </div>
    <div style="flex: 1; min-width: 200px; margin: 10px;">
        <img src="https://github.com/user-attachments/assets/15ea87de-16be-41f4-8d59-ba7a225e97e7" alt="4" style="width: 100%;">
    </div>
    <div style="flex: 1; min-width: 200px; margin: 10px;">
        <img src="https://github.com/user-attachments/assets/c5512719-c068-4a71-9e02-3d0e118ad088" alt="5" style="width: 100%;">
    </div>
</div>

<p>- 점주의 경우 가게를 등록할 수 있으며, 새 가게 채널이 형성되면 서버는 unique한 가게 암호를 반환합니다.</p>
<p>- 알바는 계좌번호를 입력하고, 사장님께 전달받은 가게 암호를 입력해 채널 멤버가 될 수 있습니다.</p>


## 🫠 마이페이지

<div style="display: flex; flex-wrap: wrap;">
    <div style="flex: 1; min-width: 150px; margin: 10px;">
        <img src="https://prod-files-secure.s3.us-west-2.amazonaws.com/ddc2d81d-71ed-4615-ba74-fbf87105c78f/ce3830b1-0dcc-4197-b0bc-7fcf1b204af7/6.png" alt="6" style="width: 100%;">
    </div>
    <div style="flex: 1; min-width: 150px; margin: 10px;">
        <img src="https://prod-files-secure.s3.us-west-2.amazonaws.com/ddc2d81d-71ed-4615-ba74-fbf87105c78f/719e6b87-ddbf-4beb-8fb0-1e952d2b1bef/7.png" alt="7" style="width: 100%;">
    </div>
    <div style="flex: 1; min-width: 150px; margin: 10px;">
        <img src="https://prod-files-secure.s3.us-west-2.amazonaws.com/ddc2d81d-71ed-4615-ba74-fbf87105c78f/f68707aa-08f9-4aed-adfe-cf29f95d0e77/8.png" alt="8" style="width: 100%;">
    </div>
    <div style="flex: 1; min-width: 150px; margin: 10px;">
        <img src="https://prod-files-secure.s3.us-west-2.amazonaws.com/ddc2d81d-71ed-4615-ba74-fbf87105c78f/f595f246-7d36-4822-810f-2e44737ffb27/9.png" alt="9" style="width: 100%;">
    </div>
</div>

- 점주는 마이페이지에서 가게 채널을 관리할 수 있습니다.
    - 일일 시간표를 수정하고 새로운 task 추가 가능
        
        <aside>
        💡 점주가 task를 등록하면 `add_task` api를 이용해서 task의 내용과  날짜, 배정된 직원 등의 정보를 DB에 저장합니다.
        
        </aside>
        
    - 매일 갱신되는 공지 보드 작성 가능
        
        <aside>
        💡 점주가 공지를 작성하면 `edit_notice`  api를 이용해서 해당 가게의 공지사항 정보를 업데이트합니다.
        
        </aside>
        
    - 알바생의 출퇴근 시간 및 급여 조회 가능
        
        <aside>
        💡 `get_store_members` api를 이용해서 DB에 저장되어 있는 해당 가게 직원들의 리스트를 불러옵니다.
        `get_member_work_time`, `get_user_wage` api를 이용해 각 직원들의 출퇴근 및 휴식시간, 시급을 가져와 월급을 계산해서 화면에 표시합니다.
        
        </aside>
        
    - 가게 채널 삭제 가능
        
        <aside>
        💡 점주는 자신의 채널을 선택해 삭제할 수 있습니다.
        
        </aside>
        
- 알바는 마이페이지에서 자신의 계정 정보를 조회할 수 있습니다.

## 🫠 홈화면 / 게시판

<div style="display: flex; flex-wrap: wrap; justify-content: space-between;">
    <div style="flex: 1 1 calc(25% - 10px); margin: 5px;">
        <img src="https://prod-files-secure.s3.us-west-2.amazonaws.com/ddc2d81d-71ed-4615-ba74-fbf87105c78f/821c276e-e820-45a0-9f20-803800177d2e/Screenshot_20240725-204633.jpg" alt="10" style="width: 100%;">
    </div>
    <div style="flex: 1 1 calc(25% - 10px); margin: 5px;">
        <img src="https://prod-files-secure.s3.us-west-2.amazonaws.com/ddc2d81d-71ed-4615-ba74-fbf87105c78f/6f2af2a9-1c82-4544-a1c7-8d64a9a3de68/Screenshot_20240725-205147.jpg" alt="11" style="width: 100%;">
    </div>
    <div style="flex: 1 1 calc(25% - 10px); margin: 5px;">
        <img src="https://prod-files-secure.s3.us-west-2.amazonaws.com/ddc2d81d-71ed-4615-ba74-fbf87105c78f/acd18ee4-50b4-4473-8dc0-d6af5a69f7b4/Screenshot_20240725-205322.jpg" alt="12" style="width: 100%;">
    </div>
    <div style="flex: 1 1 calc(25% - 10px); margin: 5px;">
        <img src="https://prod-files-secure.s3.us-west-2.amazonaws.com/ddc2d81d-71ed-4615-ba74-fbf87105c78f/96719392-d038-4340-85f9-c1069a45ef3d/Screenshot_20240725-205331.jpg" alt="13" style="width: 100%;">
    </div>
</div>

- GigHub의 꽃🌻이라 할 수 있는 게시판 기능!
- Slack, Discord 등의 커뮤니티 플랫폼처럼 각 목적에 따라 다양한 방을 만들고,
- 방에서 게시글을 추가해 멤버와 소통하고,
- 가게의 공지와 업무 시간표, 급여를 조회할 수 있습니다!
    
    <aside>
    💡 글을 작성하면 작성자, 작성시간, 제목, 내용 등의 게시글 정보가 DB에 저장됩니다.
    이후에 다른 직원이 게시판을 들어가면 DB에 있는 정보를 불러와 게시글을 보여줍니다.
    
    </aside>
    

## 🫠 하단 네비게이션 바

![14](https://github.com/user-attachments/assets/94b35636-9baf-4f80-b1a1-d720d9213934)

![15](https://github.com/user-attachments/assets/8ae7b2e3-ccb7-4e24-8873-29c9f46327bf)

### 멤버 탭

- 우리 가게에는 어떤 사람들이 있을까? 🫂**멤버 탭**에 들어가면 현재 채널의 다른 유저들을 볼 수 있습니다.
    
    <aside>
    💡 `get_store_members` api를 이용해서 가게에 가입한 알바생의 목록을 보여줍니다.
    
    </aside>
    

### 출첵봇 탭

- 알바생은 자신의 출/퇴근 시간, 휴식 시간을 **⏱️출첵봇 탭**에서 기록할 수 있습니다.
- 출퇴근 기록은 `attendance` 테이블에 저장되어, 유저는 출석 현황 로그를 조회할 수 있습니다.

# 기술 구현

- FE : Flutter
- BE : nodejs, MySQL
- Design : Figma
- IDE : VSCode

### ERD

![erd.png](https://prod-files-secure.s3.us-west-2.amazonaws.com/ddc2d81d-71ed-4615-ba74-fbf87105c78f/33431c69-3071-4c79-b1b1-9c267163c488/erd.png)

그리고 노력의 흔적…

![Untitled](https://prod-files-secure.s3.us-west-2.amazonaws.com/ddc2d81d-71ed-4615-ba74-fbf87105c78f/54a078e0-4ec0-483d-96a2-d1cd29ba3198/Untitled.png)

![Untitled](https://prod-files-secure.s3.us-west-2.amazonaws.com/ddc2d81d-71ed-4615-ba74-fbf87105c78f/12a79a3c-6ddf-4562-9f79-698cd7464b74/Untitled.png)

![Untitled](https://prod-files-secure.s3.us-west-2.amazonaws.com/ddc2d81d-71ed-4615-ba74-fbf87105c78f/6fc36b8b-db9e-4d2c-abae-601446baa4a1/Untitled.png)

# 느낀 점

- 이재희

8일동안 한 번도 써보지 않은 툴(nodejs, mysql 등)을 사용해서 개발했는데 처음에는 막막했지만 열심히 한 보람이 있는 결과물이 나와서 좋았다. 아쉬운 점도 많지만, 다음에 기회가 된다면 db를 더욱 짜임새있게 구축해보고 싶다. 

- 이은영

프론트엔드를 배워보고 싶다는 마음에 flutter를 처음 배워봤고, 생각보다 굉장히 재미있었다. front와 back 사이에 소통하는 것이 중요하다는 것을 느낄 수 있었고, 새로운 것을 많이 배울 수 있었다. 중간에 컴퓨터가 고장나서 고통을 겪었지만 극복했다!
