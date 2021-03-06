toc.dat                                                                                             0000600 0004000 0002000 00000411736 14172533476 0014467 0                                                                                                    ustar 00postgres                        postgres                        0000000 0000000                                                                                                                                                                        PGDMP           &                 z            trello_version_3    13.5    13.5 ?    _           0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                      false         `           0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                      false         a           0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                      false         b           1262    18270    trello_version_3    DATABASE     t   CREATE DATABASE trello_version_3 WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE = 'English_United States.1251';
     DROP DATABASE trello_version_3;
                postgres    false                     2615    18271    auth    SCHEMA        CREATE SCHEMA auth;
    DROP SCHEMA auth;
                postgres    false                     2615    18272    buildins    SCHEMA        CREATE SCHEMA buildins;
    DROP SCHEMA buildins;
                postgres    false         	            2615    18273    checks    SCHEMA        CREATE SCHEMA checks;
    DROP SCHEMA checks;
                postgres    false                     2615    18274    mappers    SCHEMA        CREATE SCHEMA mappers;
    DROP SCHEMA mappers;
                postgres    false                     2615    18275    organization    SCHEMA        CREATE SCHEMA organization;
    DROP SCHEMA organization;
                postgres    false                     2615    18276 
   permission    SCHEMA        CREATE SCHEMA permission;
    DROP SCHEMA permission;
                postgres    false                     2615    18277    project    SCHEMA        CREATE SCHEMA project;
    DROP SCHEMA project;
                postgres    false                     2615    18278    settings    SCHEMA        CREATE SCHEMA settings;
    DROP SCHEMA settings;
                postgres    false                     2615    18279    task    SCHEMA        CREATE SCHEMA task;
    DROP SCHEMA task;
                postgres    false                     2615    18280    utils    SCHEMA        CREATE SCHEMA utils;
    DROP SCHEMA utils;
                postgres    false                     3079    18281    pgcrypto 	   EXTENSION     >   CREATE EXTENSION IF NOT EXISTS pgcrypto WITH SCHEMA buildins;
    DROP EXTENSION pgcrypto;
                   false    13         c           0    0    EXTENSION pgcrypto    COMMENT     <   COMMENT ON EXTENSION pgcrypto IS 'cryptographic functions';
                        false    2         ?           1247    18744    auth_user_block_dto    TYPE     y   CREATE TYPE auth.auth_user_block_dto AS (
	userid bigint,
	block_for character varying,
	block_till character varying
);
 $   DROP TYPE auth.auth_user_block_dto;
       auth          postgres    false    6         $           1247    18320    auth_user_create_dto    TYPE       CREATE TYPE auth.auth_user_create_dto AS (
	username character varying,
	email character varying,
	phone character varying,
	password character varying,
	organization_id bigint,
	first_name character varying,
	language character varying,
	last_name character varying
);
 %   DROP TYPE auth.auth_user_create_dto;
       auth          postgres    false    6         '           1247    18323    organization_create_dto    TYPE     ?   CREATE TYPE organization.organization_create_dto AS (
	name character varying,
	website character varying,
	email character varying,
	logo character varying,
	reg_number character varying,
	location point
);
 0   DROP TYPE organization.organization_create_dto;
       organization          postgres    false    14         *           1247    18326    organization_update_dto    TYPE     ?   CREATE TYPE organization.organization_update_dto AS (
	id bigint,
	website character varying,
	email character varying,
	logo character varying,
	location point
);
 0   DROP TYPE organization.organization_update_dto;
       organization          postgres    false    14         -           1247    18329    permission_set_dto    TYPE     Q   CREATE TYPE permission.permission_set_dto AS (
	id bigint,
	permission bigint
);
 )   DROP TYPE permission.permission_set_dto;
    
   permission          postgres    false    16         0           1247    18332    column_create_dto    TYPE     ?   CREATE TYPE project.column_create_dto AS (
	name character varying,
	project_id bigint,
	"order" smallint,
	emoji character varying
);
 %   DROP TYPE project.column_create_dto;
       project          postgres    false    15         3           1247    18335    column_update_dto    TYPE     ?   CREATE TYPE project.column_update_dto AS (
	name character varying,
	emoji character varying,
	"order" smallint,
	column_id bigint
);
 %   DROP TYPE project.column_update_dto;
       project          postgres    false    15         6           1247    18338    project_create_dto    TYPE     ?   CREATE TYPE project.project_create_dto AS (
	name character varying,
	tz character varying,
	description text,
	background character varying,
	organization_id bigint
);
 &   DROP TYPE project.project_create_dto;
       project          postgres    false    15         9           1247    18341    project_update_dto    TYPE     ?   CREATE TYPE project.project_update_dto AS (
	id bigint,
	name character varying,
	tz character varying,
	description text,
	background character varying,
	organization_id bigint
);
 &   DROP TYPE project.project_update_dto;
       project          postgres    false    15         ?           1247    18751    task_add_comment_dto    TYPE     M   CREATE TYPE task.task_add_comment_dto AS (
	message text,
	task_id bigint
);
 %   DROP TYPE task.task_add_comment_dto;
       task          postgres    false    7         <           1247    18344    task_create_dto    TYPE     ?   CREATE TYPE task.task_create_dto AS (
	name character varying,
	description text,
	project_column_id bigint,
	deadline timestamp without time zone,
	"order" smallint,
	level bigint,
	priority bigint
);
     DROP TYPE task.task_create_dto;
       task          postgres    false    7         ?           1247    18347    task_update_dto    TYPE     ?   CREATE TYPE task.task_update_dto AS (
	id bigint,
	name character varying,
	description text,
	project_column_id bigint,
	deadline timestamp with time zone,
	"order" smallint,
	level bigint,
	priority bigint
);
     DROP TYPE task.task_update_dto;
       task          postgres    false    7         '           1255    18348    auth_user_info(bigint)    FUNCTION     ?  CREATE FUNCTION auth.auth_user_info(userid bigint) RETURNS text
    LANGUAGE plpgsql
    AS $$
declare
begin
    return json_agg((select row_to_json("table")
                     from (select au.id,
                                  au.code,
                                  au.username userName,
                                  au.first_name firstName,
                                  au.last_name  lastName,
                                  au.phone,
                                  au.email,
                                  au.language
                           from auth.auth_user au
                           where au.id = userid) "table"));
end
$$;
 2   DROP FUNCTION auth.auth_user_info(userid bigint);
       auth          postgres    false    6         ?           1255    18746    block_user(text, bigint)    FUNCTION     ?  CREATE FUNCTION auth.block_user(dataparam text, userid bigint) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
DECLARE
    dto       auth.auth_user_block_dto;
    t_mem     auth.auth_user%rowtype;
    t_auth    auth.auth_user%rowtype;
    t_block_u auth.auth_blocked_user%rowtype;
begin

    call utils.check_data(dataparam);

    dto = mappers.to_user_block_dto(dataparam::json);

    select * into t_mem from auth.auth_user where id = dto.userid;

    t_auth = auth.is_active(userid);
    if not (auth.hasanyrole('ADMIN#HR', userid) or t_auth.is_super_user or
            t_auth.organization_id = t_mem.organization_id) then
        raise exception 'PERMISSION_DENIED';
    end if;

    if exists(select
              from auth.auth_blocked_user bl
              where bl.user_id = t_mem.id
                and not bl.is_deleted) then
        raise exception 'USER_ALREADY_BLOCKED';
    end if;

    if t_mem.is_deleted or not FOUND then
        raise exception 'USER_NOT_FOUND';
    end if;

    insert into auth.auth_blocked_user (user_id, blocked_by, blocked_for, blocked_till)
    values (dto.userid, userid, dto.block_for, to_timestamp(dto.block_till, 'YYYY-MM-DD HH24:MI:SS'));

    return true;
end
$$;
 >   DROP FUNCTION auth.block_user(dataparam text, userid bigint);
       auth          postgres    false    6         7           1255    18349    create_user(text, bigint)    FUNCTION     ?  CREATE FUNCTION auth.create_user(dataparam text, userid bigint) RETURNS bigint
    LANGUAGE plpgsql
    AS $$
declare
    t_session_user auth.auth_user%rowtype;
    dto            auth.auth_user_create_dto;
    new_id         bigint;
begin
    t_session_user = auth.is_active(userid);
    if not (auth.hasAnyRole('ADMIN#HR', userid) or t_session_user.is_super_user) then
        raise exception '%',utils.error_message('PERMISSION_DENIED', t_session_user.language);
    end if;

    call utils.check_data(data := dataparam);
    dto = mappers.to_auth_user_create_dto(dataparam::json);
    dto = checks.check_auth_user_create_dto(dto);

    if not (t_session_user.is_super_user or t_session_user.organization_id = dto.organization_id) then
        raise exception 'PERMISSION_DENIED';
    end if;

    insert into auth.auth_user (password, email, phone, first_name, last_name, organization_id, status, language,
                                created_by, username)
    values (utils.encode_password(dto.password), dto.email, dto.phone, dto.first_name, dto.last_name,
            dto.organization_id, 0, dto.language,
            userid, dto.username)
    returning id into new_id;
    return new_id;
end
$$;
 ?   DROP FUNCTION auth.create_user(dataparam text, userid bigint);
       auth          postgres    false    6         ?           1255    18747    delete_user(bigint, bigint)    FUNCTION     \  CREATE FUNCTION auth.delete_user(target_userid bigint, userid bigint) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
DECLARE
    t_mem  auth.auth_user%rowtype;
    t_auth auth.auth_user%rowtype;
begin
    --     t_mem = auth.is_active(target_userid);'
    t_auth = auth.is_active(userid);
    select * into t_mem from auth.auth_user where id = target_userid and not is_deleted;
    if not FOUND then
        raise exception 'USER_NOT_FOUND';
    end if;

    if not (auth.hasanyrole('ADMIN#HR', userid) or t_auth.is_super_user or
            t_auth.organization_id = t_mem.organization_id) then
        raise exception 'PERMISSION_DENIED';
    end if;

    if t_mem.is_deleted then
        raise exception 'USER_NOT_FOUND';
    end if;

    update auth.auth_user set is_deleted = true where id = target_userid;
    return true;
end
$$;
 E   DROP FUNCTION auth.delete_user(target_userid bigint, userid bigint);
       auth          postgres    false    6         8           1255    18350    get_project_id(bigint)    FUNCTION     ?   CREATE FUNCTION auth.get_project_id(userid bigint) RETURNS bigint
    LANGUAGE plpgsql
    AS $$
declare
    v_id int8;
begin
    select project_id into v_id from project.project_member where user_id =userid ;
    return v_id;
end
$$;
 2   DROP FUNCTION auth.get_project_id(userid bigint);
       auth          postgres    false    6         9           1255    18351 +   hasanypermission(character varying, bigint)    FUNCTION     ?  CREATE FUNCTION auth.hasanypermission(permissions character varying, userid bigint) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
begin
    return exists(select ap.id
                  from auth.auth_permission ap
                           inner join auth.auth_user_permission arp on ap.id = arp.permission_id
                  where arp.user_id = userid
                    and ap.code = any (string_to_array(permissions, '#')));
end
$$;
 S   DROP FUNCTION auth.hasanypermission(permissions character varying, userid bigint);
       auth          postgres    false    6         :           1255    18352 %   hasanyrole(character varying, bigint)    FUNCTION     ?  CREATE FUNCTION auth.hasanyrole(roles character varying, userid bigint) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
begin
    return exists(select *
                  from auth.auth_user_role aur
                  where aur.user_id = userid
                    and aur.role_id in (select id
                                        from auth.auth_role
                                        where code = any (string_to_array(roles, '#'))));
end
$$;
 G   DROP FUNCTION auth.hasanyrole(roles character varying, userid bigint);
       auth          postgres    false    6         ;           1255    18353    is_active(bigint)    FUNCTION     ?  CREATE FUNCTION auth.is_active(v_user_id bigint) RETURNS record
    LANGUAGE plpgsql
    AS $$
declare
    t_auth_user    auth.auth_user%rowtype;
    t_organization organization.organization%rowtype;
    t_block_user   auth.auth_blocked_user%rowtype;
BEGIN
    select * into t_auth_user from auth.auth_user where not is_deleted and id = v_user_id;
    if not FOUND then
        raise exception 'USER_NOT_FOUND';
    end if;

    if t_auth_user.status <> 0 then
        raise exception 'USER_NOT_ACTIVE';
    end if;
    select *
    into t_block_user
    from auth.auth_blocked_user ab
    where not is_deleted
      and ab.user_id = v_user_id
    order by ab.blocked_till desc
    limit 1;

    if FOUND then
        raise exception 'USER_BLOCKED';
    end if;

    select *
    into t_organization
    from organization.organization o
    where not o.is_deleted
      and o.id = t_auth_user.organization_id;

    if not FOUND then
        raise exception 'ORGANIZATION_NOT_FOUND';
    end if;

    if t_organization.paid_for <= current_timestamp or t_organization.status <> 0 then
        raise exception 'ORGANIZATION_NOT_ACTIVE';
    end if;

    return t_auth_user;
END;
$$;
 0   DROP FUNCTION auth.is_active(v_user_id bigint);
       auth          postgres    false    6         <           1255    18354 1   login(character varying, character varying, text) 	   PROCEDURE     ?  CREATE PROCEDURE auth.login(uname character varying, pswd character varying, INOUT _out text DEFAULT NULL::text)
    LANGUAGE plpgsql
    AS $$
declare
    t_auth_user         record;
    t_auth_blocked_user record;
    t_organization      organization.organization%rowtype;
    response            jsonb;
    v_login_try_count   smallint;
    v_state             varchar;
    v_msg               varchar;
    v_detail            varchar;
    v_hint              varchar;
    v_context           varchar;
begin
    select * into t_auth_user from auth.auth_user where not is_deleted and username ilike uname;

    IF NOT FOUND then
        raise exception '%',utils.error_message('BAD_CREDENTIALS');
    END IF;

    select *
    into t_auth_blocked_user
    from auth.auth_blocked_user abu
    where not abu.is_deleted
      and abu.user_id = t_auth_user.id
    order by abu.blocked_till desc
    limit 1;

    if FOUND then
        raise exception '%',utils.error_message(t_auth_blocked_user.blocked_for);
    end if;

    if t_auth_user.status <> 0 then
        raise exception 'USER_NOT_ACTIVE';
    end if;

    if not utils.match_password(pswd, t_auth_user.password) then
        update auth.auth_user
        set login_try_count = login_try_count + 1
        where id = t_auth_user.id
        returning login_try_count into v_login_try_count;
                
        if v_login_try_count = 3 then
            insert into auth.auth_blocked_user (user_id, blocked_for, blocked_till, blocked_by)
            values (t_auth_user.id, 'ERROR_LOGIN_TRY_COUNT', now() + interval '1 min', -1);
        end if;
        commit;

        raise exception '%',utils.error_message('BAD_CREDENTIALS');
    end if;
    t_organization = organization.isorganizationactive(t_auth_user.organization_id);


    response = jsonb_build_object('id', t_auth_user.id);
    response = response || jsonb_build_object('code', t_auth_user.code);
    response = response || jsonb_build_object('username', t_auth_user.username);
    response = response || jsonb_build_object('email', t_auth_user.email);
    response = response || jsonb_build_object('phone', t_auth_user.phone);
    response = response || jsonb_build_object('first_name', t_auth_user.first_name);
    response = response || jsonb_build_object('last_name', t_auth_user.last_name);
    response = response || jsonb_build_object('created_at', t_auth_user.created_at);
    response = response || jsonb_build_object('is_super_user', t_auth_user.is_super_user);
    response = response || jsonb_build_object('language', t_auth_user.language);
    response = response || jsonb_build_object('roles', auth.user_roles(t_auth_user.id));
    response = response || jsonb_build_object('permissions', auth.user_permissions(t_auth_user.id));
    response = response || jsonb_build_object('organization', organization.organization_detail(t_organization)::jsonb);

    _out := response::text;

    -- exception
--     when others then
--         get stacked diagnostics
--             v_state = returned_sqlstate,
--             v_msg = message_text,
--             v_detail = pg_exception_detail,
--             v_hint = pg_exception_hint,
--             v_context = pg_exception_context;

    /* raise exception E'Got exception:
             state  : %
             message: %
             detail: %
             hint: %
             context: %
             SQLSTATE: %
             SQLERRM: %', v_state, v_msg, v_detail, v_hint, v_context,SQLSTATE, SQLERRM;*/
end
$$;
 ]   DROP PROCEDURE auth.login(uname character varying, pswd character varying, INOUT _out text);
       auth          postgres    false    6         ?           1255    18355    user_permissions(bigint)    FUNCTION       CREATE FUNCTION auth.user_permissions(userid bigint) RETURNS jsonb
    LANGUAGE plpgsql
    AS $$
declare
    t_user record;
begin
    return (select array_to_json(array_agg((select row_to_json("table"))))
            from (select ap.*
                  from auth.auth_user aur
                           inner join auth.auth_user_permission arp on aur.id = arp.user_id
                           inner join auth.auth_permission ap on ap.id = arp.permission_id
                  where aur.id = userid
                 ) "table");
end
$$;
 4   DROP FUNCTION auth.user_permissions(userid bigint);
       auth          postgres    false    6         =           1255    18356    user_role(bigint)    FUNCTION        CREATE FUNCTION auth.user_role(role_id bigint) RETURNS jsonb
    LANGUAGE plpgsql
    AS $$
declare
    r_auth_role record;
    response    jsonb;
begin

    select * into r_auth_role from auth.auth_role where id = role_id;
    if FOUND then
        response = jsonb_build_object('id', r_auth_role.id);
        response = response || jsonb_build_object('code', r_auth_role.code);
        response = response || jsonb_build_object('name', r_auth_role.name);
    end if;
    return response;
end
$$;
 .   DROP FUNCTION auth.user_role(role_id bigint);
       auth          postgres    false    6         >           1255    18357    user_roles(bigint)    FUNCTION     ?  CREATE FUNCTION auth.user_roles(userid bigint) RETURNS jsonb
    LANGUAGE plpgsql
    AS $$
begin
    return json_agg((select row_to_json(myTable)
                     from (select ar.*
                           from auth.auth_role ar
                                    inner join auth.auth_user_role aur on ar.id = aur.role_id
                           where aur.user_id = userid
                          ) myTable))::jsonb;
end
$$;
 .   DROP FUNCTION auth.user_roles(userid bigint);
       auth          postgres    false    6         ?           1255    18358 5   check_auth_user_create_dto(auth.auth_user_create_dto)    FUNCTION     v  CREATE FUNCTION checks.check_auth_user_create_dto(dto auth.auth_user_create_dto) RETURNS auth.auth_user_create_dto
    LANGUAGE plpgsql
    AS $_$
begin
    if dto.phone is null or dto.phone !~ '^([0-9]{12})$' then
        raise exception 'BAD_REQUEST';
    end if;

    if exists(select * from auth.auth_user where phone = dto.phone) then
        raise exception 'PHONE_IS_ALREADY_TAKEN';
    end if;

    if dto.username is null then
        raise exception 'BAD_REQUEST';
    end if;

    if exists(select * from auth.auth_user where username = dto.username) then
        raise exception 'USERNAME_IS_ALREADY_TAKEN';
    end if;

    if dto.email is null or dto.email !~ '[^@ \t\r\n]+@[^@ \t\r\n]+\.[^@ \t\r\n]+' then
        raise exception 'BAD_REQUEST';
    end if;

    if exists(select * from auth.auth_user where email = dto.email) then
        raise exception 'EMAIL_IS_ALREADY_TAKEN';
    end if;

    if dto.password is null then
        raise exception 'BAD_REQUEST';
    end if;

    if not utils.isstrongpassword(dto.password) then
        raise exception 'WEAK_PASSWORD';
    end if;

    if dto.language is null or dto.language not in (select code from settings.language) then
        dto.language = 'RU';
    end if;

    if dto.organization_id is null then
        raise exception 'BAD_REQUEST';
    end if;

    return dto;
end;
$_$;
 P   DROP FUNCTION checks.check_auth_user_create_dto(dto auth.auth_user_create_dto);
       checks          postgres    false    804    9    804         @           1255    18359 2   check_column_create_dto(project.column_create_dto)    FUNCTION     ?  CREATE FUNCTION checks.check_column_create_dto(dto project.column_create_dto) RETURNS project.column_create_dto
    LANGUAGE plpgsql
    AS $$
BEGIN
    if (dto.name) is null or dto.project_id is null then
        raise exception 'BAD_REQUEST';
    end if;

    dto.order = (select count(*) from project.project_column where project_id = dto.project_id and not is_deleted) + 1;

    return dto;
END
$$;
 M   DROP FUNCTION checks.check_column_create_dto(dto project.column_create_dto);
       checks          postgres    false    816    9    816         A           1255    18360 C   check_organization_create_dto(organization.organization_create_dto) 	   PROCEDURE     ?  CREATE PROCEDURE checks.check_organization_create_dto(dto organization.organization_create_dto)
    LANGUAGE plpgsql
    AS $$
begin
    if (dto.name is null) then
        raise exception 'BAD_REQUEST';
    end if;

    if exists(select o.name from organization.organization o where not o.is_deleted and o.name ilike dto.name) then
        raise exception 'ORGANIZATION_NAME_ALREADY_TAKEN';
    end if;

    if (dto.reg_number is null) then
        raise exception 'BAD_REQUEST';
    end if;
end
$$;
 _   DROP PROCEDURE checks.check_organization_create_dto(dto organization.organization_create_dto);
       checks          postgres    false    9    807         B           1255    18361 C   check_organization_update_dto(organization.organization_update_dto)    FUNCTION       CREATE FUNCTION checks.check_organization_update_dto(dto organization.organization_update_dto) RETURNS organization.organization_update_dto
    LANGUAGE plpgsql
    AS $$
declare
    t_organization record;
begin
    if (dto.id is null) then
        raise exception 'BAD_REQUEST';
    end if;

    select * into t_organization from organization.organization where not is_deleted and id = dto.id;
    if not FOUND then
        raise exception 'ORGANIZATION_NOT_FOUND';
    end if;

    if (dto.email is null) then
        dto.email = t_organization.email;
    end if;

    if (dto.logo is null) then
        dto.logo = t_organization.logo;
    end if;

    if (dto.website is null) then
        dto.website = t_organization.website;
    end if;

    if (dto.location is null) then
        dto.location = t_organization.location;
    end if;

    return dto;
end
$$;
 ^   DROP FUNCTION checks.check_organization_update_dto(dto organization.organization_update_dto);
       checks          postgres    false    810    9    810         C           1255    18362 7   check_permission_set_dto(permission.permission_set_dto)    FUNCTION     t  CREATE FUNCTION checks.check_permission_set_dto(dto permission.permission_set_dto) RETURNS permission.permission_set_dto
    LANGUAGE plpgsql
    AS $$
declare
begin
    if dto.id is null then
        raise exception 'ID_NOT_PROVIDED';
    end if;
    
    if dto.permission is null then
        raise exception 'ID_NOT_PROVIDED';
    end if;
    
    return dto;
end
$$;
 R   DROP FUNCTION checks.check_permission_set_dto(dto permission.permission_set_dto);
       checks          postgres    false    813    813    9         D           1255    18363 4   check_project_create_dto(project.project_create_dto)    FUNCTION       CREATE FUNCTION checks.check_project_create_dto(dto project.project_create_dto) RETURNS project.project_create_dto
    LANGUAGE plpgsql
    AS $$
DECLARE
BEGIN
    if (dto.name is null) then
        raise exception 'BAD_REQUEST';
    end if;
    return dto;
END
$$;
 O   DROP FUNCTION checks.check_project_create_dto(dto project.project_create_dto);
       checks          postgres    false    822    9    822         (           1255    18364 4   check_project_update_dto(project.project_update_dto)    FUNCTION     ?  CREATE FUNCTION checks.check_project_update_dto(dto project.project_update_dto) RETURNS project.project_update_dto
    LANGUAGE plpgsql
    AS $$
declare
    t_project project.project%rowtype;
begin
    if dto.id is null then
        raise exception 'ID_NOT_PROVIDED';
    end if;

    if dto.organization_id is null then
        raise exception 'BAD_REQUEST';
    end if;

    select * into t_project from project.project p where p.id = dto.id;
    if not found or not t_project.organization_id = dto.organization_id then
        raise exception 'PROJECT_NOT_FOUND';
    end if;

    if dto.name is null then
        dto.name := t_project.name;
    end if;

    if dto.background is null then
        dto.background := t_project.background;
    end if;

    if dto.tz is null then
        dto.tz := t_project.tz;
    end if;

    if dto.description is null then
        dto.description := t_project.description;
    end if;
    
    return dto;
end
$$;
 O   DROP FUNCTION checks.check_project_update_dto(dto project.project_update_dto);
       checks          postgres    false    9    825    825         )           1255    18365 +   check_task_create_dto(task.task_create_dto)    FUNCTION     s  CREATE FUNCTION checks.check_task_create_dto(dto task.task_create_dto) RETURNS task.task_create_dto
    LANGUAGE plpgsql
    AS $$
begin
    if dto.name is null then
        raise exception 'NAME_NOT_PROVIDED';
    end if;

    if dto.project_column_id is null then
        raise exception 'PROJECT_COLUMN_ID_NOT_PROVIDED';
    end if;
    return dto;
end
$$;
 F   DROP FUNCTION checks.check_task_create_dto(dto task.task_create_dto);
       checks          postgres    false    9    828    828         F           1255    18366 +   check_task_update_dto(task.task_update_dto)    FUNCTION     c  CREATE FUNCTION checks.check_task_update_dto(dto task.task_update_dto) RETURNS task.task_update_dto
    LANGUAGE plpgsql
    AS $$
declare
    t_task task.task%rowtype;
begin
    if dto.id is null then
        raise exception 'ID_NOT_PROVIDED';
    end if;
    
    if dto.project_column_id is null then
        raise exception 'PROJECT_COLUMN_ID_NOT_PROVIDED';
    end if;

--    if exists(select * from project.project_column where id= dto.project_column_id) then
--     raise exception 'INVALID_COLUMN_ID';
-- end if;
    
    select * into t_task from task.task where task.id = dto.id;
    
    if dto.name is null then
        dto.name = t_task.name;
    end if;
    
    if dto.deadline is null then
        dto.deadline = t_task.deadline;
    end if;

    if dto.description is null then
        dto.description = t_task.description;
    end if;

    if dto.priority is null then
        dto.priority = t_task.priority;
    end if;

    if dto.level is null then
        dto.level = t_task.level;
    end if;

    if dto."order" is null then
        dto."order" = t_task."order";
    end if;
    return dto;
end
$$;
 F   DROP FUNCTION checks.check_task_update_dto(dto task.task_update_dto);
       checks          postgres    false    9    831    831         G           1255    18367 (   is_admin_of_organization(bigint, bigint)    FUNCTION     T  CREATE FUNCTION checks.is_admin_of_organization(userid bigint, organizationid bigint) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
DECLARE
    t_auth_user auth.auth_user%rowtype;
BEGIN
    t_auth_user = auth.is_active(userid);
    return (t_auth_user.organization_id = organizationid and auth.hasanyrole('ADMIN', userid));
END
$$;
 U   DROP FUNCTION checks.is_admin_of_organization(userid bigint, organizationid bigint);
       checks          postgres    false    9         H           1255    18368 !   is_project_member(bigint, bigint)    FUNCTION     /  CREATE FUNCTION checks.is_project_member(userid bigint, projectid bigint) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
BEGIN
    return exists(select *
                  from project.project_member
                  where project_id = projectid and user_id = userid and not is_deleted);
END
$$;
 I   DROP FUNCTION checks.is_project_member(userid bigint, projectid bigint);
       checks          postgres    false    9         I           1255    18369    to_auth_user_create_dto(json)    FUNCTION     N  CREATE FUNCTION mappers.to_auth_user_create_dto(data json) RETURNS auth.auth_user_create_dto
    LANGUAGE plpgsql
    AS $$
declare
    response auth.auth_user_create_dto;
begin
    response.username := data ->> 'username';
    response.password := data ->> 'password';
    response.email := data ->> 'email';
    response.phone := data ->> 'phone';
    response.language := data ->> 'language';
    response.first_name := data ->> 'firstName';
    response.last_name := data ->> 'lastName';
    response.organization_id := (data ->> 'organizationId')::bigint;
    return response;
end
$$;
 :   DROP FUNCTION mappers.to_auth_user_create_dto(data json);
       mappers          postgres    false    11    804         J           1255    18370    to_column_create_dto(json)    FUNCTION     E  CREATE FUNCTION mappers.to_column_create_dto(data json) RETURNS project.column_create_dto
    LANGUAGE plpgsql
    AS $$
DECLARE
    dto project.column_create_dto;
BEGIN
    dto.project_id = (data ->> 'project_id')::bigint;
    dto.name = data ->> 'name';
    dto.emoji = data ->> 'emoji';

    return dto;
END
$$;
 7   DROP FUNCTION mappers.to_column_create_dto(data json);
       mappers          postgres    false    11    816         ?           1255    18371     to_organization_create_dto(json)    FUNCTION     ?  CREATE FUNCTION mappers.to_organization_create_dto(data json) RETURNS organization.organization_create_dto
    LANGUAGE plpgsql
    AS $$
declare
    response organization.organization_create_dto;
begin
    response.name := data ->> 'name';
    response.website := data ->> 'website';
    response.email := data ->> 'email';
    response.logo := data ->> 'logo';
    response.reg_number := data ->> 'regNumber';
--     response.location := data ->> 'location';

    return response;
end
$$;
 =   DROP FUNCTION mappers.to_organization_create_dto(data json);
       mappers          postgres    false    807    11         Q           1255    18372     to_organization_update_dto(json)    FUNCTION     ?  CREATE FUNCTION mappers.to_organization_update_dto(data json) RETURNS organization.organization_update_dto
    LANGUAGE plpgsql
    AS $$
declare
    v_dto organization.organization_update_dto;
begin
    v_dto.id = (data ->> 'id')::bigint;
    v_dto.email = data ->> 'email';
    v_dto.website = data ->> 'website';
    v_dto.logo = data ->> 'logo';
    v_dto.location = (data ->> 'location')::point;
    return v_dto;
end
$$;
 =   DROP FUNCTION mappers.to_organization_update_dto(data json);
       mappers          postgres    false    810    11         K           1255    18373    to_permission_set_dto(json)    FUNCTION     ;  CREATE FUNCTION mappers.to_permission_set_dto(data json) RETURNS permission.permission_set_dto
    LANGUAGE plpgsql
    AS $$
declare
    response permission.permission_set_dto;
begin
    response.id = (data ->> 'id')::bigint;
    response.permission = (data ->> 'permission')::bigint;
    return response;
end
$$;
 8   DROP FUNCTION mappers.to_permission_set_dto(data json);
       mappers          postgres    false    813    11         L           1255    18374    to_project_create_dto(json)    FUNCTION     s  CREATE FUNCTION mappers.to_project_create_dto(data json) RETURNS project.project_create_dto
    LANGUAGE plpgsql
    AS $$
DECLARE
    v_dto project.project_create_dto;
BEGIN
    v_dto.name = data ->> 'name';
    v_dto.description = data ->> 'description';
    v_dto.tz = data ->> 'tz';
    v_dto.background = data ->> 'background';

    return v_dto;
END
$$;
 8   DROP FUNCTION mappers.to_project_create_dto(data json);
       mappers          postgres    false    822    11         M           1255    18375    to_project_update_dto(json)    FUNCTION     ?  CREATE FUNCTION mappers.to_project_update_dto(data json) RETURNS project.project_update_dto
    LANGUAGE plpgsql
    AS $$
declare
    dto project.project_update_dto;
begin
    dto.id := data ->> 'id';
    dto.name := data ->> 'name';
    dto.description := data ->> 'description';
    dto.tz := data ->> 'tz';
    dto.background := data ->> 'background';
    dto.organization_id := data ->> 'organization_id';

    return dto;
end
$$;
 8   DROP FUNCTION mappers.to_project_update_dto(data json);
       mappers          postgres    false    11    825         ?           1255    18752    to_task_add_comment_dto(json)    FUNCTION     U  CREATE FUNCTION mappers.to_task_add_comment_dto(data json) RETURNS task.task_add_comment_dto
    LANGUAGE plpgsql
    AS $$
DECLARE
    dto task.task_add_comment_dto;
BEGIN
    dto.task_id = (data ->> 'task_id')::bigint;
    if dto.task_id is null then
        raise exception 'BAD_REQUEST';
    end if;

    if not exists(select * from task.task where dto.task_id = id) then
        raise exception 'TASK_NOT_FOUND';
    end if;

    dto.message = data ->> 'message';
    if dto.message is null then
        raise exception 'BAD_REQUEST';
    end if;

    return dto;
END
$$;
 :   DROP FUNCTION mappers.to_task_add_comment_dto(data json);
       mappers          postgres    false    11    924         N           1255    18376    to_task_create_dto(json)    FUNCTION       CREATE FUNCTION mappers.to_task_create_dto(data json) RETURNS task.task_create_dto
    LANGUAGE plpgsql
    AS $$
declare
    response task.task_create_dto;
begin
    response.name := data ->> 'name';
    response.description := data ->> 'description';
    response.project_column_id := (data ->> 'project_column_id')::bigint;
    response.deadline := (data ->> 'deadline')::timestamptz;
    response.level := data ->> 'level';
    response.priority := (data ->> 'priority')::bigint;

    return response;
end
$$;
 5   DROP FUNCTION mappers.to_task_create_dto(data json);
       mappers          postgres    false    11    828         O           1255    18377    to_task_update_dto(json)    FUNCTION     6  CREATE FUNCTION mappers.to_task_update_dto(data json) RETURNS task.task_update_dto
    LANGUAGE plpgsql
    AS $$
declare
    response task.task_update_dto;
begin
    response.id := data ->> 'id';
    response.project_column_id := data ->> 'project_column_id';
    response.name := data ->> 'name';
    response.description := data ->> 'description';
    response.priority := data ->> 'priority';
    response.level := data ->> 'level';
    response.order := data ->> 'order';
    response.deadline := data ->> 'deadline';
    return response;
end
$$;
 5   DROP FUNCTION mappers.to_task_update_dto(data json);
       mappers          postgres    false    831    11         ?           1255    18745    to_user_block_dto(json)    FUNCTION     >  CREATE FUNCTION mappers.to_user_block_dto(data json) RETURNS auth.auth_user_block_dto
    LANGUAGE plpgsql
    AS $$
declare
    dto auth.auth_user_block_dto;
BEGIN
    dto.userid = data ->> 'id';
    dto.block_for = data ->> 'blockedFor';
    dto.block_till = data ->> 'blockedTill';
    return dto;
END
$$;
 4   DROP FUNCTION mappers.to_user_block_dto(data json);
       mappers          postgres    false    921    11         P           1255    18378 /   delete_all_organization_belongs(bigint, bigint) 	   PROCEDURE     -  CREATE PROCEDURE organization.delete_all_organization_belongs(organizationid bigint, userid bigint)
    LANGUAGE plpgsql
    AS $$
declare
    v_project_id_array bigint[];
begin
    update auth.auth_user set is_deleted = true where organization_id = organizationid;

    update project.project
    set is_deleted = true,
        updated_at = now(),
        updated_by = userid
    where organization_id = organizationid
    returning id into v_project_id_array;

    update project.project_label pl
    set is_deleted = true,
        updated_at = now(),
        updated_by = userid
    where pl.project_id = any (v_project_id_array);

    update project.project_column pc
    set is_deleted = true,
        updated_at = now(),
        updated_by = userid
    where project_id = any (v_project_id_array);

end
$$;
 c   DROP PROCEDURE organization.delete_all_organization_belongs(organizationid bigint, userid bigint);
       organization          postgres    false    14         *           1255    18379    isorganizationactive(bigint)    FUNCTION       CREATE FUNCTION organization.isorganizationactive(organizationid bigint) RETURNS record
    LANGUAGE plpgsql
    AS $$
declare
    org record;
begin
    select * into org from organization.organization where not is_deleted and id = organizationid;
    if not FOUND then
        --TODO localize this
        raise exception 'ORGANIZATION_NOT_FOUND';
    end if;

    if org.status <> 0 then
        --TODO localize this
        raise exception 'ORGANIZATION_IS_NOT_ACTIVE';
    end if;
    return org;
end
$$;
 H   DROP FUNCTION organization.isorganizationactive(organizationid bigint);
       organization          postgres    false    14         0           1255    18380 "   organization_block(bigint, bigint) 	   PROCEDURE     ?   CREATE PROCEDURE organization.organization_block(organizationid bigint, userid bigint)
    LANGUAGE plpgsql
    AS $$
BEGIN
    call organization.organization_change_status(-1, organizationid, userid);
END
$$;
 V   DROP PROCEDURE organization.organization_block(organizationid bigint, userid bigint);
       organization          postgres    false    14         R           1255    18381 4   organization_change_status(smallint, bigint, bigint) 	   PROCEDURE     ?  CREATE PROCEDURE organization.organization_change_status(new_status smallint, organizationid bigint, userid bigint)
    LANGUAGE plpgsql
    AS $$
declare
    t_auth_user auth.auth_user%rowtype;
begin
    t_auth_user = auth.is_active(userid);
    if not t_auth_user.is_super_user then
        raise exception 'PERMISSION_DENIED';
    end if;

    update organization.organization
    set status = new_status
    where id = organizationid;


end
$$;
 s   DROP PROCEDURE organization.organization_change_status(new_status smallint, organizationid bigint, userid bigint);
       organization          postgres    false    14         ?           1255    18738 !   organization_create(text, bigint)    FUNCTION     6  CREATE FUNCTION organization.organization_create(dataparam text, userid bigint) RETURNS bigint
    LANGUAGE plpgsql
    AS $$
declare
    t_auth_user auth.auth_user%rowtype;
    dto         organization.organization_create_dto;
    v_id        bigint;
begin
    t_auth_user = auth.is_active(userid);

    call utils.check_data(dataparam);

    dto = mappers.to_organization_create_dto(dataparam::json);

    call checks.check_organization_create_dto(dto);

    if not t_auth_user.is_super_user then
        raise exception 'PERMISSION_DENIED';
    end if;

    insert into organization.organization (name, website, email, logo, reg_num, paid_for, created_by)
    values (dto.name, dto.website, dto.email, dto.logo, dto.reg_number, (now() + interval '1 year'), userid)
    returning id into v_id;

    return v_id;
end
$$;
 O   DROP FUNCTION organization.organization_create(dataparam text, userid bigint);
       organization          postgres    false    14         S           1255    18383 #   organization_delete(bigint, bigint) 	   PROCEDURE     ?  CREATE PROCEDURE organization.organization_delete(organizationid bigint, userid bigint)
    LANGUAGE plpgsql
    AS $$
DECLARE
    t_auth_user auth.auth_user%rowtype;
BEGIN
    t_auth_user = auth.is_active(userid);

    if not t_auth_user.is_super_user then
        raise exception 'PERMISSION_DENIED';
    end if;

    update organization.organization o
    set is_deleted = true
    where o.id = organizationid;
    call organization.delete_all_organization_belongs(organizationid, userid);

END;
$$;
 W   DROP PROCEDURE organization.organization_delete(organizationid bigint, userid bigint);
       organization          postgres    false    14         T           1255    18384    organization_detail(bigint)    FUNCTION     =  CREATE FUNCTION organization.organization_detail(organizationid bigint) RETURNS text
    LANGUAGE plpgsql
    AS $$
declare
    org              record;
    organizationJson jsonb;
begin
    select * into org from organization.organization where not is_deleted and id = organizationid;
    if not FOUND then
        --TODO localize this
        raise exception 'ORGANIZATION_NOT_FOUND';
    end if;

    if org.status <> 0 then
        --TODO localize this
        raise exception 'ORGANIZATION_IS_NOT_ACTIVE';
    end if;

    organizationJson = jsonb_build_object('id', org.id);
    organizationJson = organizationJson || jsonb_build_object('name', org.name);
    organizationJson = organizationJson || jsonb_build_object('email', org.email);
    organizationJson = organizationJson || jsonb_build_object('website', org.website);
    organizationJson = organizationJson || jsonb_build_object('logo', org.logo);
    organizationJson = organizationJson || jsonb_build_object('location', org.location);
    organizationJson = organizationJson || jsonb_build_object('created_at', org.created_at);
    organizationJson = organizationJson || jsonb_build_object('reg_num', org.reg_num);
    organizationJson = organizationJson || jsonb_build_object('paid_for', org.paid_for);
    return organizationJson::text;
end
$$;
 G   DROP FUNCTION organization.organization_detail(organizationid bigint);
       organization          postgres    false    14         U           1255    18385    organization_detail(record)    FUNCTION       CREATE FUNCTION organization.organization_detail(organization record) RETURNS text
    LANGUAGE plpgsql
    AS $$
declare
    organizationJson jsonb;
begin
    organizationJson = jsonb_build_object('id', organization.id);
    organizationJson = organizationJson || jsonb_build_object('name', organization.name);
    organizationJson = organizationJson || jsonb_build_object('email', organization.email);
    organizationJson = organizationJson || jsonb_build_object('website', organization.website);
    organizationJson = organizationJson || jsonb_build_object('logo', organization.logo);
    organizationJson = organizationJson || jsonb_build_object('location', organization.location);
    organizationJson = organizationJson || jsonb_build_object('created_at', organization.created_at);
    organizationJson = organizationJson || jsonb_build_object('reg_num', organization.reg_num);
    organizationJson = organizationJson || jsonb_build_object('paid_for', organization.paid_for);
    return organizationJson::text;
end
$$;
 E   DROP FUNCTION organization.organization_detail(organization record);
       organization          postgres    false    14         V           1255    18386    organization_list(bigint)    FUNCTION        CREATE FUNCTION organization.organization_list(userid bigint) RETURNS text
    LANGUAGE plpgsql
    AS $$
declare
    t_auth_user auth.auth_user%rowtype;
begin
    t_auth_user = auth.is_active(userid);

    if not t_auth_user.is_super_user then
        raise exception 'PERMISSION_DENIED';
    end if;

    return (select array_to_json(array_agg(row_to_json(organizationColumn)))
            from (select * from organization.organization o where not o.is_deleted) organizationColumn)::text;
end
$$;
 =   DROP FUNCTION organization.organization_list(userid bigint);
       organization          postgres    false    14         W           1255    18387 $   organization_unblock(bigint, bigint) 	   PROCEDURE     ?   CREATE PROCEDURE organization.organization_unblock(organizationid bigint, userid bigint)
    LANGUAGE plpgsql
    AS $$
BEGIN
    call organization.organization_change_status(0, organizationid, userid);
END
$$;
 X   DROP PROCEDURE organization.organization_unblock(organizationid bigint, userid bigint);
       organization          postgres    false    14         X           1255    18388 !   organization_update(text, bigint)    FUNCTION     w  CREATE FUNCTION organization.organization_update(dataparam text, userid bigint) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
DECLARE
    dto         organization.organization_update_dto;
    t_auth_user auth.auth_user%rowtype;
BEGIN

    t_auth_user = auth.is_active(userid);

    call utils.check_data(dataparam);

    dto = mappers.to_organization_update_dto(dataparam::json);

    dto = checks.check_organization_update_dto(dto);

    if not ((auth.hasanypermission('UPDATE_ORGANIZATION', userid) and t_auth_user.organization_id = dto.id)
        or t_auth_user.is_super_user) then
        raise exception 'PERMISSION_DENIED';
    end if;

    update organization.organization o
    set email    = dto.email,
        website  = dto.website,
        logo     = dto.logo,
        location = dto.location
    where o.id = dto.id;

    return true;
END;
$$;
 O   DROP FUNCTION organization.organization_update(dataparam text, userid bigint);
       organization          postgres    false    14         Y           1255    18389    permission_set(bigint, text)    FUNCTION     N  CREATE FUNCTION permission.permission_set(session bigint, dataparam text) RETURNS bigint
    LANGUAGE plpgsql
    AS $$
declare
    t_auth_user auth.auth_user%rowtype;
    v_dto       permission.permission_set_dto;
begin
    t_auth_user = auth.is_active(session);

    if not auth.hasanypermission('PERMISSION_SET', session) then
        raise exception 'PERMISSION_DENIED';
    end if;
    call utils.check_data(dataparam);
    v_dto = mappers.to_permission_set_dto(dataparam::json);
    v_dto = checks.check_permission_set_dto(v_dto);

    if exists(select user_id from auth.auth_user_permission where permission_id = v_dto.permission) then
        raise exception 'PERMISSION_ALREADY_TAKEN';
    end if;
    insert into auth.auth_user_permission (user_id, permission_id) values (v_dto.id, v_dto.permission);
    return t_auth_user.id;
end
$$;
 I   DROP FUNCTION permission.permission_set(session bigint, dataparam text);
    
   permission          postgres    false    16         [           1255    18390    isactiveproject(bigint)    FUNCTION     ?  CREATE FUNCTION project.isactiveproject(projectid bigint) RETURNS record
    LANGUAGE plpgsql
    AS $$
DECLARE
    res record;
BEGIN
    select * into res from project.project p where not p.is_deleted and p.id = projectid and p.status = 0;

    if not FOUND then
        raise exception 'PROJECT_NOT_FOUND';
    end if;

    if res.is_archived then
        raise exception 'PROJECT_IS_ARCHIVED';
    end if;

    return res;

END
$$;
 9   DROP FUNCTION project.isactiveproject(projectid bigint);
       project          postgres    false    15         \           1255    18391    isprojectmember(bigint, bigint)    FUNCTION       CREATE FUNCTION project.isprojectmember(projectid bigint, userid bigint) RETURNS record
    LANGUAGE plpgsql
    AS $$
DECLARE
    t_project_member record;
BEGIN

    select * into t_project_member
                  from project.project_member pm
                  where not pm.is_deleted
                    and pm.project_id = projectid
                    and pm.user_id = userid;
    if not found then
        raise exception 'PROJECT_MEMBERS_NOT_FOUND';
    end if;
    
    return t_project_member;
END
$$;
 H   DROP FUNCTION project.isprojectmember(projectid bigint, userid bigint);
       project          postgres    false    15         ]           1255    18392 *   project_add_member(bigint, bigint, bigint)    FUNCTION     M  CREATE FUNCTION project.project_add_member(projectid bigint, memberid bigint, userid bigint) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
declare
    t_auth_user      auth.auth_user%rowtype;
    t_project        project.project%rowtype;
    t_project_member project.project_member%rowtype;
begin
    t_auth_user = auth.is_active(memberid);
    
    t_auth_user = auth.is_active(userid);

    t_project = project.isactiveproject(projectid);

--     t_project_member = project.isprojectmember(projectid, userid);

    if not ((t_auth_user.organization_id = t_project.organization_id)
        or auth.hasanyrole('ADMIN#HR#MANAGER', userid)
        or t_project_member.is_lead) then
        raise exception 'PERMISSION_DENIED';
    end if;

    select *
    into t_project_member
    from project.project_member pm
    where pm.user_id = memberid
      and pm.project_id = project_id;
    if FOUND then
        raise exception 'MEMBER_IS_ALREADY_ADDED';
    end if;

    insert into project.project_member (project_id, user_id, created_by) values (projectid, memberid, userid);
    return true;
end
$$;
 \   DROP FUNCTION project.project_add_member(projectid bigint, memberid bigint, userid bigint);
       project          postgres    false    15         ^           1255    18393    project_block(bigint, bigint)    FUNCTION     *  CREATE FUNCTION project.project_block(userid bigint, projectid bigint) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
DECLARE
    t_project        project.project%rowtype;
    t_project_member project.project_member%rowtype;
    auth_u           auth.auth_user%rowtype;
begin
    perform auth.is_active(userid);

    t_project = project.isactiveproject(projectId);

    t_project_member = project.isprojectmember(projectId, userid);

    if not (auth_u.organization_id = t_project.organization_id
        or auth.hasanypermission('PROJECT_BLOCK', userid)
        or t_project_member.is_lead or auth.hasanyrole('ADMIN', userid)) then
        raise exception 'PERMISSION_DENIED';
    end if;

    update project.project set status = -1 where project.id = projectId;
    return true;
end
$$;
 F   DROP FUNCTION project.project_block(userid bigint, projectid bigint);
       project          postgres    false    15         _           1255    18394 -   project_column_change_order(bigint, smallint) 	   PROCEDURE     q  CREATE PROCEDURE project.project_column_change_order(columnid bigint, new_order smallint)
    LANGUAGE plpgsql
    AS $$
DECLARE
    count    smallint;
    t_pr_col project.project_column%rowtype;
BEGIN
    select pc.* into t_pr_col from project.project_column pc where pc.id = columnid;
    count = (select count(*) from project.project_column where project_id = t_pr_col.project_id and not is_deleted);

    if new_order > count and not new_order = 32000 then
        new_order = count;
    else
        if new_order < 1 then
            new_order = 1;
        end if;
    end if;

    if new_order > t_pr_col."order" then
        update project.project_column
        set "order" = "order" - 1
        where "order" <= new_order
          and "order" > t_pr_col."order"
          and id <> columnid
          and project_id = t_pr_col.project_id;

        update project.project_column
        set "order" = new_order
        where id = columnid;
    end if;

    if new_order < t_pr_col."order" then
        update project.project_column
        set "order" = "order" + 1
        where "order" >= new_order
          and "order" < t_pr_col."order"
          and id <> columnid
          and project_id = t_pr_col.project_id;

        update project.project_column
        set "order" = new_order
        where id = columnid;
    end if;

END
$$;
 Y   DROP PROCEDURE project.project_column_change_order(columnid bigint, new_order smallint);
       project          postgres    false    15         `           1255    18395 #   project_column_create(text, bigint)    FUNCTION       CREATE FUNCTION project.project_column_create(dataparam text, userid bigint) RETURNS bigint
    LANGUAGE plpgsql
    AS $$
DECLARE
    dto         project.column_create_dto;
    t_auth_user auth.auth_user%rowtype;
    pr_org_id   bigint;
    new_id      bigint;
BEGIN
    t_auth_user = auth.is_active(userid);
    call utils.check_data(dataparam);
    dto = mappers.to_column_create_dto(dataparam::json);
    dto = checks.check_column_create_dto(dto);

    select pr.organization_id
    into pr_org_id
    from project.project pr
    where id = dto.project_id
      and not is_deleted;

    if not (checks.is_project_member(userid, dto.project_id)
        or checks.is_admin_of_organization(userid, pr_org_id)) then
        raise exception 'PERMISSION_DENIED';
    end if;

    insert into project.project_column (name, emoji, project_id, "order", created_at, created_by)
    values (dto.name, dto.emoji, dto.project_id, dto.order, current_timestamp, userid)
    returning id into new_id;

    return new_id;
END
$$;
 L   DROP FUNCTION project.project_column_create(dataparam text, userid bigint);
       project          postgres    false    15         a           1255    18396 %   project_column_delete(bigint, bigint)    FUNCTION     H  CREATE FUNCTION project.project_column_delete(userid bigint, columnid bigint) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
DECLARE
    t_auth_user auth.auth_user%rowtype;
    t_pr_column record;
    t_pr_member record;
BEGIN
    t_auth_user = auth.is_active(userid);

    select pc.*, p.created_by as project_owner, p.organization_id
    into t_pr_column
    from project.project_column pc
             inner join project.project p on p.id = pc.project_id
    where pc.id = columnid
      and not p.is_deleted;

    if not FOUND then
        raise exception 'NOT_FOUND';
    end if;

    select *
    into t_pr_member
    from project.project_member
    where project_id = t_pr_column.project_id
      and not is_deleted
      and user_id = userid
      and is_lead;

    if not FOUND or not checks.is_admin_of_organization(userid, t_pr_column.organization_id) then
        raise exception 'PERMISSION_DENIED';
    end if;

    update project.project_column
    set is_deleted = true,
        updated_by = userid,
        updated_at = now()
    where id = columnid;

    update task.task
    set is_deleted = true,
        updated_at = now(),
        updated_by = userid
    where project_column_id = columnid;

    call project.change_column_order(columnid, 32000::smallint);

    return true;
END
$$;
 M   DROP FUNCTION project.project_column_delete(userid bigint, columnid bigint);
       project          postgres    false    15         d           1255    18397    project_columns_detail(bigint)    FUNCTION     ?  CREATE FUNCTION project.project_columns_detail(projectid bigint) RETURNS jsonb
    LANGUAGE plpgsql
    AS $$
DECLARE
BEGIN
    perform project.isactiveproject(projectid);
    
    return array_to_json(array_agg((select row_to_json(projectColumn)
                                    from (
                                             select pc.id, pc.name, pc.emoji, task.task_details(pc.id) as tasks
                                             from project.project_column pc
                                             where not pc.is_deleted
                                               and pc.project_id = projectid
                                             order by pc."order"
                                         ) projectColumn)));
END
$$;
 @   DROP FUNCTION project.project_columns_detail(projectid bigint);
       project          postgres    false    15         e           1255    18398    project_create(text, bigint)    FUNCTION     N  CREATE FUNCTION project.project_create(dataparam text, userid bigint) RETURNS bigint
    LANGUAGE plpgsql
    AS $$
DECLARE
    v_dto          project.project_create_dto;
    t_session_user auth.auth_user%rowtype;
    newId          bigint;
BEGIN
    t_session_user = auth.is_active(userid);
    call utils.check_data(dataparam);
    if not (auth.hasanypermission('CREATE_PROJECT', userid) or t_session_user.is_super_user) then
        raise exception 'PERMISSION_DENIED';
    end if;

    v_dto = mappers.to_project_create_dto(dataparam::json);
    v_dto.organization_id = t_session_user.organization_id;
    v_dto = checks.check_project_create_dto(v_dto);

    insert into project.project (name, code, background, tz, description, organization_id, created_by)
    values (v_dto.name, buildins.gen_random_uuid()::varchar, v_dto.background, v_dto.tz, v_dto.description,
            v_dto.organization_id, userid)
    returning id into newId;
    
    insert into project.project_member (project_id, user_id, created_by, is_lead)
    values (newId, userid, userid, true);
    
    return newId;
END
$$;
 E   DROP FUNCTION project.project_create(dataparam text, userid bigint);
       project          postgres    false    15         f           1255    18399    project_delete(bigint, bigint)    FUNCTION     ?  CREATE FUNCTION project.project_delete(userid bigint, projectid bigint) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
declare
    t_project_column_id bigint;
    t_task_id           bigint;
    t_auth_user         auth.auth_user%rowtype;
begin
    perform auth.is_active(userid);

    if not (checks.is_project_member(userid, projectid)
        or auth.hasanypermission('PROJECT_DELETE', userid)
        or auth.hasAnyRole('ADMIN', userid)) then
        raise exception 'PERMISSION_DENIED';
    end if;

    if
        exists(select * from project.project pr where is_deleted or not pr.id = projectid) then
        raise exception 'PROJECT_NOT_FOUND';
    end if;

    update project.project
    set is_deleted = true
    where project.id = projectid;

    update project.project_label
    set is_deleted = true
    where project_id = projectid;

    update project.project_column
    set is_deleted = true
    where project_id = projectid;

    update project.project_member
    set is_deleted = true
    where project_id = projectid;

    select id into t_project_column_id from project.project_column where project_id = projectid;

    update task.task
    set is_deleted = true
    where project_column_id = t_project_column_id;

    select id into t_task_id from task.task where project_column_id = t_project_column_id;
    update task.comment
    set is_deleted = true
    where task_id = task_id;

    update task.task_member
    set is_deleted = true
    where task_id = t_task_id;

    return true;
end;
$$;
 G   DROP FUNCTION project.project_delete(userid bigint, projectid bigint);
       project          postgres    false    15         g           1255    18400    project_details(bigint, bigint)    FUNCTION     ?  CREATE FUNCTION project.project_details(projectid bigint, userid bigint) RETURNS text
    LANGUAGE plpgsql
    AS $$
DECLARE
    t_session_user auth.auth_user%rowtype;
    t_project      project.project%rowtype;
    response       jsonb;
BEGIN
    t_session_user = auth.is_active(userid);
    if not (t_session_user.is_super_user
        or auth.hasanypermission('PROJECT_DETAIL', userid)
        or checks.is_project_member(projectid, userid)) then
        raise exception 'PERMISSION_DENIED';
    end if;
    t_project = project.isactiveproject(projectid);
    response = jsonb_build_object('id', projectid);
    response = response || jsonb_build_object('code', t_project.code);
    response = response || jsonb_build_object('name', t_project.name);
    response = response || jsonb_build_object('description', t_project.description);
    response = response || jsonb_build_object('tz', t_project.tz);
    response = response || jsonb_build_object('background', t_project.background);
    response = response || jsonb_build_object('organizationId', t_project.organization_id);
    response = response || jsonb_build_object('columns', project.project_columns_detail(projectid));
    response = response || jsonb_build_object('labels', project.project_labels(projectid));
    response = response || jsonb_build_object('projectMembers', project.project_members(projectid));
    return response::text;
END
$$;
 H   DROP FUNCTION project.project_details(projectid bigint, userid bigint);
       project          postgres    false    15         h           1255    18401    project_labels(bigint)    FUNCTION     ?  CREATE FUNCTION project.project_labels(projectid bigint) RETURNS jsonb
    LANGUAGE plpgsql
    AS $$
declare
begin
    perform project.isactiveproject(projectid);

    return (select array_to_json(array_agg(row_to_json("table")))
            from (select pl.id, pl.color, pl.text
                  from project.project_label pl
                  where not pl.is_deleted
                    and pl.project_id = projectid) "table");

end
$$;
 8   DROP FUNCTION project.project_labels(projectid bigint);
       project          postgres    false    15         i           1255    18402 %   project_leave(bigint, bigint, bigint)    FUNCTION     "  CREATE FUNCTION project.project_leave(mem_id bigint, projectid bigint, userid bigint) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
declare
    t_auth auth.auth_user%rowtype;
    t_pr_mem project.project_member%rowtype;
    t_pr project.project%rowtype;
    t_auth_mem auth.auth_user%rowtype;
begin
    t_auth = auth.is_active(userid);
    t_auth_mem =  auth.is_active(mem_id);

    select * into t_pr_mem  from project.project_member pmm where pmm.user_id = mem_id and pmm.project_id = project_id;
    select * into t_pr from project.project ppp where ppp.id= projectid and ppp.organization_id = t_auth.organization_id;
    if userid = mem_id then
        delete from project.project_member pp where pp.user_id = mem_id;
        return true;
    end if;

    return false;
end
$$;
 U   DROP FUNCTION project.project_leave(mem_id bigint, projectid bigint, userid bigint);
       project          postgres    false    15         j           1255    18403    project_list(bigint)    FUNCTION       CREATE FUNCTION project.project_list(userid bigint) RETURNS text
    LANGUAGE plpgsql
    AS $$
declare
    t_auth_user auth.auth_user%rowtype;
begin
    t_auth_user = auth.is_active(userid);

    if not (auth.hasanypermission('PROJECT_LIST', userid) or auth.hasanyrole('ADMIN', userid)) then
        raise exception 'PERMISSION_DENIED';
    end if;

    return (select array_to_json(array_agg(row_to_json(projectColumn)))
            from (select * from project.project p where not p.is_deleted) projectColumn)::text;
end
$$;
 3   DROP FUNCTION project.project_list(userid bigint);
       project          postgres    false    15         k           1255    18404    project_members(bigint)    FUNCTION     ?  CREATE FUNCTION project.project_members(projectid bigint) RETURNS jsonb
    LANGUAGE plpgsql
    AS $$
declare
begin
    perform project.isactiveproject(projectid);
    
    return (select array_to_json(array_agg((row_to_json("table"))))
            from (select pm.id memberId, pm.is_lead, auth.auth_user_info(pm.user_id)::jsonb userInfo
                  from project.project_member pm
                  where not pm.is_deleted
                    and pm.project_id = projectid) "table");

end
$$;
 9   DROP FUNCTION project.project_members(projectid bigint);
       project          postgres    false    15         l           1255    18405 -   project_remove_member(bigint, bigint, bigint)    FUNCTION     ?  CREATE FUNCTION project.project_remove_member(projectid bigint, memberid bigint, userid bigint) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
DECLARE
    t_mem     auth.auth_user%rowtype;
    t_user    auth.auth_user%rowtype;
    t_project project.project%rowtype;
    t_pmem    project.project_member%rowtype;
    t_user_pm project.project_member%rowtype;
begin
    t_mem = auth.is_active(memberid);
    t_user = auth.is_active(userid);
    select * into t_project from project.project pr where pr.id = projectid;
    if not FOUND then
        raise exception 'PROJECT_NOT_FOUND';
    end if;

--     if not exists(select au.organization_id
--     from auth.auth_user au
--              inner join project.project_member pm on au.id = pm.user_id
--              inner join project.project p on au.organization_id = p.organization_id
--     where au.id = userid
--       and pm.user_id = memberid
--       and p.id = projectid) then
--         raise exception 'ORGANIZATION_NOT_FOUND';
--     end if;

    select * into t_user_pm from project.project_member userpm where userpm.user_id = userid;
    if not ((t_user.organization_id = t_mem.organization_id and t_user.organization_id = t_project.organization_id) or
            auth.hasanyrole('ADMIN#HR#MANAGER', userid) or t_user_pm.is_lead or
            t_user.organization_id = t_project.organization_id) then
        raise exception 'YOU_ARE_NOT_ALLOWED';
    end if;

    select *
    into t_pmem
    from project.project_member pm
    where pm.user_id = memberid
      and pm.project_id = project_id;
    if not FOUND then
        raise exception 'MEMBER_IS_NOT_FOUND';
    end if;

    delete from project.project_member pp where pp.user_id = memberid;
    return true;
end
$$;
 _   DROP FUNCTION project.project_remove_member(projectid bigint, memberid bigint, userid bigint);
       project          postgres    false    15         m           1255    18406    project_unblock(bigint, bigint)    FUNCTION     ?  CREATE FUNCTION project.project_unblock(userid bigint, projectid bigint) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
declare
    t_project        project.project%rowtype;
    t_project_member project.project_member%rowtype;
    auth_u           auth.auth_user%rowtype;
begin
    perform auth.is_active(userid);

    t_project_member = project.isprojectmember(projectId, userid);

    select * into t_project from project.project pr where pr.id = projectId;
    if not FOUND or t_project.status = 0 or t_project.is_deleted then
        raise exception 'PROJECT_NOT_FOUND';
    end if;

    if not (auth_u.organization_id = t_project.organization_id
        or auth.hasanypermission('PROJECT_UNBLOCK', userid)
        or t_project_member.is_lead or auth.hasanyrole('ADMIN', userid)) then
        raise exception 'PERMISSION_DENIED';
    end if;

    update project.project set status = 0 where id = projectid;

    return true;
end
$$;
 H   DROP FUNCTION project.project_unblock(userid bigint, projectid bigint);
       project          postgres    false    15         n           1255    18407    project_update(bigint, text)    FUNCTION       CREATE FUNCTION project.project_update(userid bigint, dataparam text) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
declare
    dto              project.project_update_dto;
    t_project_member project.project_member%rowtype;
begin
    perform auth.is_active(userid);

    call utils.check_data(dataparam);

    dto = mappers.to_project_update_dto(dataparam::json);

    perform project.isactiveproject(dto.id);

    dto := checks.check_project_update_dto(dto);

    select * into t_project_member from project.project_member pm where pm.user_id = userid;

    if not (auth.hasanypermission('PROJECT_UPDATE', userid)
        or auth.hasanyrole('ADMIN', userid)
        or t_project_member.is_lead) then
        raise exception 'PERMISSION_DENIED';
    end if;

    update project.project
    set name        = dto.name,
        description = dto.description,
        background  = dto.background,
        tz          = dto.tz,
        updated_at  = now(),
        updated_by  = userid
    where id = dto.id;

    return true;
end;
$$;
 E   DROP FUNCTION project.project_update(userid bigint, dataparam text);
       project          postgres    false    15         o           1255    18408    to_create_project_dto(json)    FUNCTION     s  CREATE FUNCTION project.to_create_project_dto(data json) RETURNS project.project_create_dto
    LANGUAGE plpgsql
    AS $$
DECLARE
    v_dto project.project_create_dto;
BEGIN
    v_dto.name = data ->> 'name';
    v_dto.description = data ->> 'description';
    v_dto.tz = data ->> 'tz';
    v_dto.background = data ->> 'background';

    return v_dto;
END
$$;
 8   DROP FUNCTION project.to_create_project_dto(data json);
       project          postgres    false    15    822         p           1255    18409    is_active(bigint) 	   PROCEDURE     ?  CREATE PROCEDURE public.is_active(v_user_id bigint)
    LANGUAGE plpgsql
    AS $$
declare
    t_auth_user  auth.auth_user%rowtype;
    t_block_user auth.auth_blocked_user%rowtype;
BEGIN
    select * into t_auth_user from auth.auth_user where not is_deleted and id = v_user_id;
    if not FOUND then
        raise exception 'USER_NOT_FOUND';
    end if;

    if t_auth_user.status <> 0 then
        raise exception 'USER_NOT_ACTIVE';
    end if;
    select *
    into t_block_user
    from auth.auth_blocked_user ab
    where not is_deleted
      and ab.user_id = v_user_id
    order by ab.blocked_till desc
    limit 1;
    
    if FOUND then
       raise exception 'USER_BLOCKED';
    end if;
END;
$$;
 3   DROP PROCEDURE public.is_active(v_user_id bigint);
       public          postgres    false         q           1255    18410 /   delete_all_organization_belongs(bigint, bigint) 	   PROCEDURE     C  CREATE PROCEDURE settings.delete_all_organization_belongs(organizationid bigint, userid bigint)
    LANGUAGE plpgsql
    AS $$
declare
    v_project_id_array bigint[];
begin
    update auth.auth_user set is_deleted = true where organization_id = organizationid;

    update project.project
    set is_deleted = true,
        updated_at = now(),
        updated_by = userid
    where organization_id = organizationid
    returning id into v_project_id_array;

    update project.project_label pl
    set is_deleted = true,
        updated_at = now(),
        updated_by = userid
    where pl.project_id = any (v_project_id_array);

    update project.project_column pc
    set is_deleted = true,
        updated_at = now(),
        updated_by = userid
    where project_id = any (v_project_id_array);

end
$$;
 _   DROP PROCEDURE settings.delete_all_organization_belongs(organizationid bigint, userid bigint);
       settings          postgres    false    12                    1255    18736    get_user_tasks(bigint)    FUNCTION     [  CREATE FUNCTION task.get_user_tasks(userid bigint) RETURNS jsonb
    LANGUAGE plpgsql
    AS $$
DECLARE
BEGIN
    perform auth.is_active(userid);
    return (select array_to_json(array_agg(row_to_json("table")))
            from (
                     select t.id,
                            t.name,
                            t.description,
                            t.deadline,
                            task.task_level_val(t.level)       as level,
                            task.task_priority_val(t.priority) as priority,
                            task.task_members_details(t.id)    as members,
                            task.task_comments(t.id) ::jsonb          as comments
                     from task.task t inner join task.task_member tm on t.id = tm.task_id and tm.user_id = user_id
                 ) "table");
END
$$;
 2   DROP FUNCTION task.get_user_tasks(userid bigint);
       task          postgres    false    7         ?           1255    18737 %   remove_member(bigint, bigint, bigint)    FUNCTION       CREATE FUNCTION task.remove_member(userid bigint, taskid bigint, session_id bigint) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
declare
    t_session_user auth.auth_user%rowtype;
    v_project_id   bigint;
begin
    t_session_user = auth.is_active(session_id);
    v_project_id = auth.get_project_id(session_id);
    if not (auth.hasanyrole('ADMIN', session_id) OR
            exists(select *
                   from task.task_member tm
                            inner join task.task t
                                       on t.id = taskid and tm.user_id = userid and tm.task_id = taskid)) then
        raise exception 'PERMISSION_DENIED';
    end if;
    update trello_version_3.task.task_member set is_deleted = true where user_id = userid;
    return true;
end
$$;
 S   DROP FUNCTION task.remove_member(userid bigint, taskid bigint, session_id bigint);
       task          postgres    false    7         ?           1255    18753    task_add_comment(text, bigint)    FUNCTION     ?  CREATE FUNCTION task.task_add_comment(dataparam text, userid bigint) RETURNS bigint
    LANGUAGE plpgsql
    AS $$
DECLARE
    dto           task.task_add_comment_dto;
    t_auth_user   auth.auth_user%rowtype;
    t_task_column record;
    new_id        bigint;
BEGIN
    t_auth_user = auth.is_active(userid);
    dto = mappers.to_task_add_comment_dto(dataparam::json);
    select t.*, pc.project_id
    into t_task_column
    from task.task t
             inner join project.project_column pc on t.project_column_id = pc.id
    where t.id = dto.task_id;

    if not checks.is_project_member(userid, t_task_column.project_id) then
        raise exception 'PERMISSION_DENIED';
    end if;

    insert into task.comment (message, task_id, created_at, created_by)
    values (dto.message, dto.task_id, now(), userid)
    returning id into new_id;

    return new_id;
END
$$;
 D   DROP FUNCTION task.task_add_comment(dataparam text, userid bigint);
       task          postgres    false    7         r           1255    18411 '   task_add_member(bigint, bigint, bigint)    FUNCTION     ?  CREATE FUNCTION task.task_add_member(userid bigint, taskid bigint, session_id bigint) RETURNS bigint
    LANGUAGE plpgsql
    AS $$
declare
    t_session_user auth.auth_user%rowtype;
    target_user    auth.auth_user%rowtype;
    new_member     bigint;
begin
    t_session_user = auth.is_active(session_id);
    target_user = auth.is_active(userid);

    if not t_session_user.organization_id = target_user.organization_id then
        raise exception 'TARGET_USER_NOT_FOUND';
    end if;

    if not (auth.hasanyrole('ADMIN', session_id) OR
            exists(select *
                   from task.task t
                            inner join project.project_column pc on t.project_column_id = pc.id
                            inner join project.project_member pm on pm.project_id = pc.project_id
                   where pm.is_lead
                     and pm.user_id = session_id
                     and t.id = taskid)) then
        raise exception '%',utils.error_message('PERMISSION_DENIED', t_session_user.language);
    end if;

    insert into task.task_member (user_id, task_id, created_by)
    values (userid, taskid, session_id)
    returning id into new_member;

    return new_member;
end
$$;
 U   DROP FUNCTION task.task_add_member(userid bigint, taskid bigint, session_id bigint);
       task          postgres    false    7         t           1255    18412 #   task_change_order(bigint, smallint) 	   PROCEDURE       CREATE PROCEDURE task.task_change_order(taskid bigint, new_order smallint)
    LANGUAGE plpgsql
    AS $$
DECLARE
    count  smallint;
    t_task task.task%rowtype;
BEGIN
    select t.* into t_task from task.task t where t.id = taskid;
    count = (select count(*) from task.task where project_column_id = t_task.project_column_id and not is_deleted);

    if new_order > count and not new_order = 32000 then
        new_order = count;
    else
        if new_order < 1 then
            new_order = 1;
        end if;
    end if;

    if new_order > t_task."order" then
        update task.task
        set "order" = "order" - 1
        where "order" <= new_order
          and "order" > t_task."order"
          and id <> taskid
          and project_column_id = t_task.project_column_id;

        update task.task
        set "order" = new_order
        where id = taskid;
    end if;

    if new_order < t_task."order" then
        update task.task
        set "order" = "order" + 1
        where "order" >= new_order
          and "order" < t_task."order"
          and id <> taskid
          and project_column_id = t_task.project_column_id;

        update task.task
        set "order" = new_order
        where id = taskid;
    end if;
END
$$;
 J   DROP PROCEDURE task.task_change_order(taskid bigint, new_order smallint);
       task          postgres    false    7         u           1255    18413    task_comments(bigint)    FUNCTION     g  CREATE FUNCTION task.task_comments(taskid bigint) RETURNS text
    LANGUAGE plpgsql
    AS $$
declare
begin
    return (select array_to_json(array_agg((row_to_json("table"))))
            from (select tc.*
                  from task.comment tc
                  where not tc.is_deleted
                    and tc.task_id = taskid) "table");
end
$$;
 1   DROP FUNCTION task.task_comments(taskid bigint);
       task          postgres    false    7         v           1255    18414    task_create(text, bigint)    FUNCTION     p  CREATE FUNCTION task.task_create(dataparam text, userid bigint) RETURNS bigint
    LANGUAGE plpgsql
    AS $$
declare
    t_session_user auth.auth_user%rowtype;
    dto            task.task_create_dto;
    new_id         bigint;
    v_order        smallint;
    v_project_id   bigint;
begin
    --CHECK USER FOR PERMISSION AND ACTIVE
    t_session_user = auth.is_active(userid);
    v_project_id = auth.get_project_id(userid);
    if v_project_id is null or
       not (exists(select * from project.project_member where is_lead and user_id = t_session_user.id)
           or checks.is_project_member(v_project_id, userid)
           or t_session_user.is_super_user
           or auth.hasanyrole('ADMIN', t_session_user.id)) then
        raise exception '%',utils.error_message('PERMISSION_DENIED', t_session_user.language);
    end if;

    --CHECK DATA_PARAM 
    call utils.check_data(data := dataparam);
    dto = mappers.to_task_create_dto(dataparam::json);
    dto = checks.check_task_create_dto(dto);

    --GENERATE ORDER TO LAST 
    select tt."order"
    into v_order
    from task.task tt
    where not tt.is_deleted
      and tt.project_column_id = dto.project_column_id
    order by tt."order" desc
    limit 1;
    if not FOUND then
        v_order = 1;
    else
        v_order = v_order + 1;
    end if;

    --INSERTION
    insert into task.task (name, description, project_column_id, deadline, "order", level, priority, created_by)
    values (dto.name, dto.description, dto.project_column_id, dto.deadline, v_order, dto.level, dto.priority,
            t_session_user.id)
    returning id into new_id;

    return new_id;
end
$$;
 ?   DROP FUNCTION task.task_create(dataparam text, userid bigint);
       task          postgres    false    7         w           1255    18415    task_delete(bigint, bigint) 	   PROCEDURE     ?  CREATE PROCEDURE task.task_delete(userid bigint, taskid bigint)
    LANGUAGE plpgsql
    AS $$
declare
    t_session_user auth.auth_user%rowtype;
    t_task         task.task%rowtype;
begin
    t_session_user = auth.is_active(userid);

    select * into t_task from task.task t where not t.is_deleted and t.id = taskid;
    if not FOUND then
        raise exception 'TASK_NOT_FOUND';
    end if;

    if not (t_task.created_by = t_session_user.id or exists(select *
                                                            from task.task_member tm
                                                            where tm.created_by = t_session_user.id)) then
        raise exception '%',utils.error_message('PERMISSION_DENIED', t_session_user.language);
    end if;

    call task.task_change_order(taskid::bigint, 32000::smallint);

    update task.task set is_deleted = true where id = t_task.id;
end
$$;
 ?   DROP PROCEDURE task.task_delete(userid bigint, taskid bigint);
       task          postgres    false    7         x           1255    18416    task_details(bigint)    FUNCTION     u  CREATE FUNCTION task.task_details(projectcolumnid bigint) RETURNS jsonb
    LANGUAGE plpgsql
    AS $$
DECLARE
BEGIN
    return (select array_to_json(array_agg(row_to_json("table")))
            from (
                     select t.id,
                            t.name,
                            t.description,
                            t.deadline,
                            task.task_level_val(t.level)       as level,
                            task.task_priority_val(t.priority) as priority,
                            task.task_members_details(t.id)    as members,
                            task.task_comments(t.id) ::jsonb          as comments
                     from task.task t
                     where not t.is_deleted
                       and t.project_column_id = projectcolumnid
                     order by t."order"
                 ) "table");
END
$$;
 9   DROP FUNCTION task.task_details(projectcolumnid bigint);
       task          postgres    false    7         y           1255    18417    task_level_val(bigint)    FUNCTION     ?   CREATE FUNCTION task.task_level_val(level bigint) RETURNS character varying
    LANGUAGE plpgsql
    AS $$
begin
    return (select s.value from settings.settings s where s.id = level);
end
$$;
 1   DROP FUNCTION task.task_level_val(level bigint);
       task          postgres    false    7         z           1255    18418    task_members_details(bigint)    FUNCTION     z  CREATE FUNCTION task.task_members_details(taskid bigint) RETURNS jsonb
    LANGUAGE plpgsql
    AS $$
begin
    return (select array_to_json(array_agg(row_to_json(user_table)))
            from (select tm.id memberId, auth.auth_user_info(tm.user_id)::jsonb userInfo
                  from task.task_member tm
                  where tm.task_id = taskid) as user_table);
end
$$;
 8   DROP FUNCTION task.task_members_details(taskid bigint);
       task          postgres    false    7         {           1255    18419    task_priority_val(bigint)    FUNCTION     ?   CREATE FUNCTION task.task_priority_val(priority bigint) RETURNS character varying
    LANGUAGE plpgsql
    AS $$
begin
    return (select s.value from settings.settings s where s.id = priority);
end
$$;
 7   DROP FUNCTION task.task_priority_val(priority bigint);
       task          postgres    false    7         |           1255    18420    task_update(text, bigint)    FUNCTION       CREATE FUNCTION task.task_update(dataparam text, userid bigint) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
declare
    dto            task.task_update_dto;
    t_session_user auth.auth_user%rowtype;
    v_project_id   bigint;
begin
    --CHECK USER FOR ACTIVE AND PERMISSION
    t_session_user := auth.is_active(userid);
    v_project_id = auth.get_project_id(userid);
    if v_project_id is null or
       not (exists(select * from project.project_member where is_lead and user_id = t_session_user.id)
           or checks.is_project_member(v_project_id, userid)
           or t_session_user.is_super_user
           or auth.hasanyrole('ADMIN', t_session_user.id)) then
        raise exception '%',utils.error_message('PERMISSION_DENIED', t_session_user.language);
    end if;

    select pm.project_id into v_project_id from project.project_member pm where pm.user_id = t_session_user.id;

    --CHECK DATA_PARAM
    call utils.check_data(data := dataparam);
    dto = mappers.to_task_update_dto(dataparam::json);
    dto = checks.check_task_update_dto(dto);

--     if not exists(select * from task.task_member tm where tm.user_id = t_session_user.id and tm.task_id = dto.id) then
--         raise exception 'TASK_NOT_FOUND';
--     end if;

    if not exists(select *
                  from project.project_column pc
                  where pc.id = dto.project_column_id
                    and pc.project_id = v_project_id) then
        raise exception '%',utils.error_message('PERMISSION_DENIED', t_session_user.language);
    end if;

    update task.task
    set name              = dto.name,
        description       = dto.description,
        level             = dto.level,
--         "order"           = dto."order",
        priority          = dto.priority,
        project_column_id = dto.project_column_id,
        deadline          = dto.deadline,
        updated_by        = t_session_user.id,
        updated_at        = now()
    where id = dto.id;

    call task.task_change_order(dto.id,dto."order");

    return true;
end
$$;
 ?   DROP FUNCTION task.task_update(dataparam text, userid bigint);
       task          postgres    false    7         E           1255    18421    check_data(text) 	   PROCEDURE     ?   CREATE PROCEDURE utils.check_data(data text)
    LANGUAGE plpgsql
    AS $$
begin
    if '{}'::text = data or '' = data then
        raise exception 'DATA_IS_INVALID';
    end if;
end
$$;
 ,   DROP PROCEDURE utils.check_data(data text);
       utils          postgres    false    5         Z           1255    18422 "   encode_password(character varying)    FUNCTION     ?   CREATE FUNCTION utils.encode_password(raw_password character varying) RETURNS character varying
    LANGUAGE plpgsql
    AS $$
begin
    return buildIns.crypt(raw_password, buildIns.gen_salt('bf', 4));
end;
$$;
 E   DROP FUNCTION utils.encode_password(raw_password character varying);
       utils          postgres    false    5         b           1255    18423     error_message(character varying)    FUNCTION     ?   CREATE FUNCTION utils.error_message(error_code character varying) RETURNS text
    LANGUAGE plpgsql
    AS $$
declare
begin

    return utils.error_message(error_code, 'RU');
end
$$;
 A   DROP FUNCTION utils.error_message(error_code character varying);
       utils          postgres    false    5         s           1255    18424 3   error_message(character varying, character varying)    FUNCTION     M  CREATE FUNCTION utils.error_message(error_code character varying, language_code character varying) RETURNS text
    LANGUAGE plpgsql
    AS $$
declare
begin

    return (select mt.text
            from settings.message_translations mt
            WHERE mt.message = error_code
              and mt.language = language_code);
end
$$;
 b   DROP FUNCTION utils.error_message(error_code character varying, language_code character varying);
       utils          postgres    false    5         &           1255    18425    gen_number(integer)    FUNCTION       CREATE FUNCTION utils.gen_number(digits_count integer) RETURNS bigint
    LANGUAGE plpgsql
    AS $$
declare
    min int8;
    max int8;
begin
    min = pow(10, digits_count - 1);
    max = pow(10, digits_count) - 1;
    return cast(round(random() * (max - min) + min) as int8);
end
$$;
 6   DROP FUNCTION utils.gen_number(digits_count integer);
       utils          postgres    false    5         c           1255    18426 #   isstrongpassword(character varying)    FUNCTION     ?   CREATE FUNCTION utils.isstrongpassword(raw_password character varying) RETURNS boolean
    LANGUAGE plpgsql
    AS $_$
begin
    return raw_password ~ '^(?=.*[A-Z])(?=.*[!@#$&*_])(?=.*[0-9])(?=.*[a-z].*[a-z].*[a-z]).{8,}$';
end;
$_$;
 F   DROP FUNCTION utils.isstrongpassword(raw_password character varying);
       utils          postgres    false    5         }           1255    18427 !   langid_by_code(character varying)    FUNCTION     ?  CREATE FUNCTION utils.langid_by_code(language_code character varying) RETURNS bigint
    LANGUAGE plpgsql
    AS $$
declare
    v_id bigint;
begin
    select id into v_id from settings.language l where l.code = language_code;
    if FOUND then
        return v_id;
        else
        return (select id from settings.language l where l.code='RU');
    end if;

end ;
$$;
 E   DROP FUNCTION utils.langid_by_code(language_code character varying);
       utils          postgres    false    5         ~           1255    18428 4   match_password(character varying, character varying)    FUNCTION     ?   CREATE FUNCTION utils.match_password(raw_password character varying, encoded_password character varying) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
begin
    return encoded_password = buildIns.crypt(raw_password, encoded_password);
end
$$;
 h   DROP FUNCTION utils.match_password(raw_password character varying, encoded_password character varying);
       utils          postgres    false    5         ?            1259    18429    auth_blocked_user    TABLE       CREATE TABLE auth.auth_blocked_user (
    id bigint NOT NULL,
    user_id bigint,
    blocked_for character varying,
    blocked_at timestamp with time zone DEFAULT now(),
    blocked_till timestamp with time zone,
    blocked_by bigint,
    is_deleted boolean DEFAULT false
);
 #   DROP TABLE auth.auth_blocked_user;
       auth         heap    postgres    false    6         ?            1259    18437    auth_blocked_user_id_seq    SEQUENCE        CREATE SEQUENCE auth.auth_blocked_user_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 -   DROP SEQUENCE auth.auth_blocked_user_id_seq;
       auth          postgres    false    221    6         d           0    0    auth_blocked_user_id_seq    SEQUENCE OWNED BY     Q   ALTER SEQUENCE auth.auth_blocked_user_id_seq OWNED BY auth.auth_blocked_user.id;
          auth          postgres    false    222         ?            1259    18439    auth_permission    TABLE     v   CREATE TABLE auth.auth_permission (
    id bigint NOT NULL,
    code character varying,
    name character varying
);
 !   DROP TABLE auth.auth_permission;
       auth         heap    postgres    false    6         ?            1259    18445    auth_permission_id_seq    SEQUENCE     }   CREATE SEQUENCE auth.auth_permission_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 +   DROP SEQUENCE auth.auth_permission_id_seq;
       auth          postgres    false    6    223         e           0    0    auth_permission_id_seq    SEQUENCE OWNED BY     M   ALTER SEQUENCE auth.auth_permission_id_seq OWNED BY auth.auth_permission.id;
          auth          postgres    false    224         ?            1259    18447 	   auth_role    TABLE     ?   CREATE TABLE auth.auth_role (
    id bigint NOT NULL,
    code character varying,
    name character varying,
    order_value integer DEFAULT 0 NOT NULL
);
    DROP TABLE auth.auth_role;
       auth         heap    postgres    false    6         ?            1259    18453    auth_role_id_seq    SEQUENCE     w   CREATE SEQUENCE auth.auth_role_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 %   DROP SEQUENCE auth.auth_role_id_seq;
       auth          postgres    false    225    6         f           0    0    auth_role_id_seq    SEQUENCE OWNED BY     A   ALTER SEQUENCE auth.auth_role_id_seq OWNED BY auth.auth_role.id;
          auth          postgres    false    226         ?            1259    18455    auth_role_permission    TABLE     Y   CREATE TABLE auth.auth_role_permission (
    role_id bigint,
    permission_id bigint
);
 &   DROP TABLE auth.auth_role_permission;
       auth         heap    postgres    false    6         ?            1259    18458 	   auth_user    TABLE     !  CREATE TABLE auth.auth_user (
    id bigint NOT NULL,
    password character varying NOT NULL,
    code character varying DEFAULT (buildins.gen_random_uuid())::text,
    email character varying NOT NULL,
    phone character varying NOT NULL,
    first_name character varying,
    last_name character varying,
    is_super_user boolean DEFAULT false,
    last_login_time timestamp with time zone,
    login_try_count smallint DEFAULT 0,
    organization_id bigint NOT NULL,
    status smallint DEFAULT '-1'::integer,
    language character varying NOT NULL,
    is_deleted boolean DEFAULT false,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    created_by bigint NOT NULL,
    updated_at timestamp with time zone,
    updated_by bigint,
    username character varying NOT NULL
);
    DROP TABLE auth.auth_user;
       auth         heap    postgres    false    2    13    6         ?            1259    18470    auth_user_id_seq    SEQUENCE     w   CREATE SEQUENCE auth.auth_user_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 %   DROP SEQUENCE auth.auth_user_id_seq;
       auth          postgres    false    228    6         g           0    0    auth_user_id_seq    SEQUENCE OWNED BY     A   ALTER SEQUENCE auth.auth_user_id_seq OWNED BY auth.auth_user.id;
          auth          postgres    false    229         ?            1259    18472    auth_user_permission    TABLE     Y   CREATE TABLE auth.auth_user_permission (
    user_id bigint,
    permission_id bigint
);
 &   DROP TABLE auth.auth_user_permission;
       auth         heap    postgres    false    6         ?            1259    18475    auth_user_role    TABLE     M   CREATE TABLE auth.auth_user_role (
    user_id bigint,
    role_id bigint
);
     DROP TABLE auth.auth_user_role;
       auth         heap    postgres    false    6         ?            1259    18478    organization    TABLE     ?  CREATE TABLE organization.organization (
    id bigint NOT NULL,
    name character varying NOT NULL,
    website character varying,
    email character varying,
    logo character varying,
    reg_num character varying NOT NULL,
    status smallint DEFAULT 0,
    paid_for timestamp with time zone,
    location point DEFAULT point((2)::double precision, (3)::double precision),
    created_at timestamp with time zone DEFAULT now(),
    created_by bigint,
    is_deleted boolean DEFAULT false
);
 &   DROP TABLE organization.organization;
       organization         heap    postgres    false    14         ?            1259    18488    organization_id_seq    SEQUENCE     ?   CREATE SEQUENCE organization.organization_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 0   DROP SEQUENCE organization.organization_id_seq;
       organization          postgres    false    14    232         h           0    0    organization_id_seq    SEQUENCE OWNED BY     W   ALTER SEQUENCE organization.organization_id_seq OWNED BY organization.organization.id;
          organization          postgres    false    233         ?            1259    18490    project    TABLE     	  CREATE TABLE project.project (
    id bigint NOT NULL,
    name character varying NOT NULL,
    code character varying NOT NULL,
    background character varying,
    is_archived boolean DEFAULT false,
    tz character varying,
    description text,
    organization_id bigint,
    is_deleted boolean DEFAULT false,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    created_by bigint NOT NULL,
    updated_at timestamp with time zone,
    updated_by bigint,
    status smallint DEFAULT 0 NOT NULL
);
    DROP TABLE project.project;
       project         heap    postgres    false    15         ?            1259    18500    project_column    TABLE     o  CREATE TABLE project.project_column (
    id bigint NOT NULL,
    name character varying,
    emoji character varying,
    project_id bigint,
    "order" smallint,
    is_deleted boolean DEFAULT false,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    created_by bigint NOT NULL,
    updated_at timestamp with time zone,
    updated_by bigint
);
 #   DROP TABLE project.project_column;
       project         heap    postgres    false    15         ?            1259    18508    project_column_id_seq    SEQUENCE        CREATE SEQUENCE project.project_column_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 -   DROP SEQUENCE project.project_column_id_seq;
       project          postgres    false    235    15         i           0    0    project_column_id_seq    SEQUENCE OWNED BY     Q   ALTER SEQUENCE project.project_column_id_seq OWNED BY project.project_column.id;
          project          postgres    false    236         ?            1259    18510    project_id_seq    SEQUENCE     x   CREATE SEQUENCE project.project_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 &   DROP SEQUENCE project.project_id_seq;
       project          postgres    false    234    15         j           0    0    project_id_seq    SEQUENCE OWNED BY     C   ALTER SEQUENCE project.project_id_seq OWNED BY project.project.id;
          project          postgres    false    237         ?            1259    18512    project_label    TABLE     a  CREATE TABLE project.project_label (
    id bigint NOT NULL,
    text character varying,
    color character varying NOT NULL,
    project_id bigint,
    is_deleted boolean DEFAULT false,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    created_by bigint NOT NULL,
    updated_at timestamp with time zone,
    updated_by bigint
);
 "   DROP TABLE project.project_label;
       project         heap    postgres    false    15         ?            1259    18520    project_label_id_seq    SEQUENCE     ?   ALTER TABLE project.project_label ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME project.project_label_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    MAXVALUE 2147483647
    CACHE 1
);
            project          postgres    false    238    15         ?            1259    18522    project_member    TABLE     W  CREATE TABLE project.project_member (
    id bigint NOT NULL,
    project_id bigint,
    user_id bigint,
    is_lead boolean DEFAULT false,
    is_deleted boolean DEFAULT false,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    created_by bigint NOT NULL,
    updated_at timestamp with time zone,
    updated_by bigint
);
 #   DROP TABLE project.project_member;
       project         heap    postgres    false    15         ?            1259    18528    project_member_id_seq    SEQUENCE     ?   ALTER TABLE project.project_member ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME project.project_member_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);
            project          postgres    false    240    15         ?            1259    18530    language    TABLE     |   CREATE TABLE settings.language (
    id bigint NOT NULL,
    name character varying,
    code character varying NOT NULL
);
    DROP TABLE settings.language;
       settings         heap    postgres    false    12         ?            1259    18536    language_id_seq    SEQUENCE     z   CREATE SEQUENCE settings.language_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 (   DROP SEQUENCE settings.language_id_seq;
       settings          postgres    false    242    12         k           0    0    language_id_seq    SEQUENCE OWNED BY     G   ALTER SEQUENCE settings.language_id_seq OWNED BY settings.language.id;
          settings          postgres    false    243         ?            1259    18538    message    TABLE     (  CREATE TABLE settings.message (
    id bigint NOT NULL,
    code character varying NOT NULL,
    is_deleted boolean DEFAULT false,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    created_by bigint NOT NULL,
    updated_at timestamp with time zone,
    updated_by bigint
);
    DROP TABLE settings.message;
       settings         heap    postgres    false    12         ?            1259    18546    message_id_seq    SEQUENCE     y   CREATE SEQUENCE settings.message_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 '   DROP SEQUENCE settings.message_id_seq;
       settings          postgres    false    244    12         l           0    0    message_id_seq    SEQUENCE OWNED BY     E   ALTER SEQUENCE settings.message_id_seq OWNED BY settings.message.id;
          settings          postgres    false    245         ?            1259    18548    message_translations    TABLE     ?   CREATE TABLE settings.message_translations (
    id bigint NOT NULL,
    message character varying,
    language character varying,
    text character varying NOT NULL
);
 *   DROP TABLE settings.message_translations;
       settings         heap    postgres    false    12         ?            1259    18554    message_translations_id_seq    SEQUENCE     ?   CREATE SEQUENCE settings.message_translations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 4   DROP SEQUENCE settings.message_translations_id_seq;
       settings          postgres    false    246    12         m           0    0    message_translations_id_seq    SEQUENCE OWNED BY     _   ALTER SEQUENCE settings.message_translations_id_seq OWNED BY settings.message_translations.id;
          settings          postgres    false    247         ?            1259    18556    settings    TABLE     t   CREATE TABLE settings.settings (
    id bigint NOT NULL,
    code character varying,
    value character varying
);
    DROP TABLE settings.settings;
       settings         heap    postgres    false    12         ?            1259    18562    settings_id_seq    SEQUENCE     z   CREATE SEQUENCE settings.settings_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 (   DROP SEQUENCE settings.settings_id_seq;
       settings          postgres    false    248    12         n           0    0    settings_id_seq    SEQUENCE OWNED BY     G   ALTER SEQUENCE settings.settings_id_seq OWNED BY settings.settings.id;
          settings          postgres    false    249         ?            1259    18564    comment    TABLE     6  CREATE TABLE task.comment (
    id bigint NOT NULL,
    message text,
    type bigint,
    task_id bigint,
    is_deleted boolean DEFAULT false,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    created_by bigint NOT NULL,
    updated_at timestamp with time zone,
    updated_by bigint
);
    DROP TABLE task.comment;
       task         heap    postgres    false    7         ?            1259    18572    comment_id_seq    SEQUENCE     u   CREATE SEQUENCE task.comment_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 #   DROP SEQUENCE task.comment_id_seq;
       task          postgres    false    250    7         o           0    0    comment_id_seq    SEQUENCE OWNED BY     =   ALTER SEQUENCE task.comment_id_seq OWNED BY task.comment.id;
          task          postgres    false    251         ?            1259    18574    task    TABLE     ?  CREATE TABLE task.task (
    id bigint NOT NULL,
    name character varying NOT NULL,
    description text,
    project_column_id bigint,
    deadline timestamp with time zone,
    "order" smallint,
    level bigint,
    priority bigint,
    is_deleted boolean DEFAULT false,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    created_by bigint NOT NULL,
    updated_at timestamp with time zone,
    updated_by bigint
);
    DROP TABLE task.task;
       task         heap    postgres    false    7         ?            1259    18582    task_id_seq    SEQUENCE     r   CREATE SEQUENCE task.task_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
     DROP SEQUENCE task.task_id_seq;
       task          postgres    false    7    252         p           0    0    task_id_seq    SEQUENCE OWNED BY     7   ALTER SEQUENCE task.task_id_seq OWNED BY task.task.id;
          task          postgres    false    253         ?            1259    18584    task_member    TABLE     +  CREATE TABLE task.task_member (
    id bigint NOT NULL,
    user_id bigint,
    task_id bigint,
    is_deleted boolean DEFAULT false,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    created_by bigint NOT NULL,
    updated_at timestamp with time zone,
    updated_by bigint
);
    DROP TABLE task.task_member;
       task         heap    postgres    false    7         ?            1259    18589    task_member_id_seq    SEQUENCE     y   CREATE SEQUENCE task.task_member_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 '   DROP SEQUENCE task.task_member_id_seq;
       task          postgres    false    7    254         q           0    0    task_member_id_seq    SEQUENCE OWNED BY     E   ALTER SEQUENCE task.task_member_id_seq OWNED BY task.task_member.id;
          task          postgres    false    255         O           2604    18591    auth_blocked_user id    DEFAULT     x   ALTER TABLE ONLY auth.auth_blocked_user ALTER COLUMN id SET DEFAULT nextval('auth.auth_blocked_user_id_seq'::regclass);
 A   ALTER TABLE auth.auth_blocked_user ALTER COLUMN id DROP DEFAULT;
       auth          postgres    false    222    221         P           2604    18592    auth_permission id    DEFAULT     t   ALTER TABLE ONLY auth.auth_permission ALTER COLUMN id SET DEFAULT nextval('auth.auth_permission_id_seq'::regclass);
 ?   ALTER TABLE auth.auth_permission ALTER COLUMN id DROP DEFAULT;
       auth          postgres    false    224    223         Q           2604    18593    auth_role id    DEFAULT     h   ALTER TABLE ONLY auth.auth_role ALTER COLUMN id SET DEFAULT nextval('auth.auth_role_id_seq'::regclass);
 9   ALTER TABLE auth.auth_role ALTER COLUMN id DROP DEFAULT;
       auth          postgres    false    226    225         Y           2604    18594    auth_user id    DEFAULT     h   ALTER TABLE ONLY auth.auth_user ALTER COLUMN id SET DEFAULT nextval('auth.auth_user_id_seq'::regclass);
 9   ALTER TABLE auth.auth_user ALTER COLUMN id DROP DEFAULT;
       auth          postgres    false    229    228         ^           2604    18595    organization id    DEFAULT     ~   ALTER TABLE ONLY organization.organization ALTER COLUMN id SET DEFAULT nextval('organization.organization_id_seq'::regclass);
 D   ALTER TABLE organization.organization ALTER COLUMN id DROP DEFAULT;
       organization          postgres    false    233    232         c           2604    18596 
   project id    DEFAULT     j   ALTER TABLE ONLY project.project ALTER COLUMN id SET DEFAULT nextval('project.project_id_seq'::regclass);
 :   ALTER TABLE project.project ALTER COLUMN id DROP DEFAULT;
       project          postgres    false    237    234         f           2604    18597    project_column id    DEFAULT     x   ALTER TABLE ONLY project.project_column ALTER COLUMN id SET DEFAULT nextval('project.project_column_id_seq'::regclass);
 A   ALTER TABLE project.project_column ALTER COLUMN id DROP DEFAULT;
       project          postgres    false    236    235         l           2604    18598    language id    DEFAULT     n   ALTER TABLE ONLY settings.language ALTER COLUMN id SET DEFAULT nextval('settings.language_id_seq'::regclass);
 <   ALTER TABLE settings.language ALTER COLUMN id DROP DEFAULT;
       settings          postgres    false    243    242         o           2604    18599 
   message id    DEFAULT     l   ALTER TABLE ONLY settings.message ALTER COLUMN id SET DEFAULT nextval('settings.message_id_seq'::regclass);
 ;   ALTER TABLE settings.message ALTER COLUMN id DROP DEFAULT;
       settings          postgres    false    245    244         p           2604    18600    message_translations id    DEFAULT     ?   ALTER TABLE ONLY settings.message_translations ALTER COLUMN id SET DEFAULT nextval('settings.message_translations_id_seq'::regclass);
 H   ALTER TABLE settings.message_translations ALTER COLUMN id DROP DEFAULT;
       settings          postgres    false    247    246         q           2604    18601    settings id    DEFAULT     n   ALTER TABLE ONLY settings.settings ALTER COLUMN id SET DEFAULT nextval('settings.settings_id_seq'::regclass);
 <   ALTER TABLE settings.settings ALTER COLUMN id DROP DEFAULT;
       settings          postgres    false    249    248         t           2604    18602 
   comment id    DEFAULT     d   ALTER TABLE ONLY task.comment ALTER COLUMN id SET DEFAULT nextval('task.comment_id_seq'::regclass);
 7   ALTER TABLE task.comment ALTER COLUMN id DROP DEFAULT;
       task          postgres    false    251    250         w           2604    18603    task id    DEFAULT     ^   ALTER TABLE ONLY task.task ALTER COLUMN id SET DEFAULT nextval('task.task_id_seq'::regclass);
 4   ALTER TABLE task.task ALTER COLUMN id DROP DEFAULT;
       task          postgres    false    253    252         z           2604    18604    task_member id    DEFAULT     l   ALTER TABLE ONLY task.task_member ALTER COLUMN id SET DEFAULT nextval('task.task_member_id_seq'::regclass);
 ;   ALTER TABLE task.task_member ALTER COLUMN id DROP DEFAULT;
       task          postgres    false    255    254         :          0    18429    auth_blocked_user 
   TABLE DATA           u   COPY auth.auth_blocked_user (id, user_id, blocked_for, blocked_at, blocked_till, blocked_by, is_deleted) FROM stdin;
    auth          postgres    false    221       3386.dat <          0    18439    auth_permission 
   TABLE DATA           7   COPY auth.auth_permission (id, code, name) FROM stdin;
    auth          postgres    false    223       3388.dat >          0    18447 	   auth_role 
   TABLE DATA           >   COPY auth.auth_role (id, code, name, order_value) FROM stdin;
    auth          postgres    false    225       3390.dat @          0    18455    auth_role_permission 
   TABLE DATA           D   COPY auth.auth_role_permission (role_id, permission_id) FROM stdin;
    auth          postgres    false    227       3392.dat A          0    18458 	   auth_user 
   TABLE DATA           ?   COPY auth.auth_user (id, password, code, email, phone, first_name, last_name, is_super_user, last_login_time, login_try_count, organization_id, status, language, is_deleted, created_at, created_by, updated_at, updated_by, username) FROM stdin;
    auth          postgres    false    228       3393.dat C          0    18472    auth_user_permission 
   TABLE DATA           D   COPY auth.auth_user_permission (user_id, permission_id) FROM stdin;
    auth          postgres    false    230       3395.dat D          0    18475    auth_user_role 
   TABLE DATA           8   COPY auth.auth_user_role (user_id, role_id) FROM stdin;
    auth          postgres    false    231       3396.dat E          0    18478    organization 
   TABLE DATA           ?   COPY organization.organization (id, name, website, email, logo, reg_num, status, paid_for, location, created_at, created_by, is_deleted) FROM stdin;
    organization          postgres    false    232       3397.dat G          0    18490    project 
   TABLE DATA           ?   COPY project.project (id, name, code, background, is_archived, tz, description, organization_id, is_deleted, created_at, created_by, updated_at, updated_by, status) FROM stdin;
    project          postgres    false    234       3399.dat H          0    18500    project_column 
   TABLE DATA           ?   COPY project.project_column (id, name, emoji, project_id, "order", is_deleted, created_at, created_by, updated_at, updated_by) FROM stdin;
    project          postgres    false    235       3400.dat K          0    18512    project_label 
   TABLE DATA           ?   COPY project.project_label (id, text, color, project_id, is_deleted, created_at, created_by, updated_at, updated_by) FROM stdin;
    project          postgres    false    238       3403.dat M          0    18522    project_member 
   TABLE DATA           ?   COPY project.project_member (id, project_id, user_id, is_lead, is_deleted, created_at, created_by, updated_at, updated_by) FROM stdin;
    project          postgres    false    240       3405.dat O          0    18530    language 
   TABLE DATA           4   COPY settings.language (id, name, code) FROM stdin;
    settings          postgres    false    242       3407.dat Q          0    18538    message 
   TABLE DATA           i   COPY settings.message (id, code, is_deleted, created_at, created_by, updated_at, updated_by) FROM stdin;
    settings          postgres    false    244       3409.dat S          0    18548    message_translations 
   TABLE DATA           M   COPY settings.message_translations (id, message, language, text) FROM stdin;
    settings          postgres    false    246       3411.dat U          0    18556    settings 
   TABLE DATA           5   COPY settings.settings (id, code, value) FROM stdin;
    settings          postgres    false    248       3413.dat W          0    18564    comment 
   TABLE DATA           w   COPY task.comment (id, message, type, task_id, is_deleted, created_at, created_by, updated_at, updated_by) FROM stdin;
    task          postgres    false    250       3415.dat Y          0    18574    task 
   TABLE DATA           ?   COPY task.task (id, name, description, project_column_id, deadline, "order", level, priority, is_deleted, created_at, created_by, updated_at, updated_by) FROM stdin;
    task          postgres    false    252       3417.dat [          0    18584    task_member 
   TABLE DATA           u   COPY task.task_member (id, user_id, task_id, is_deleted, created_at, created_by, updated_at, updated_by) FROM stdin;
    task          postgres    false    254       3419.dat r           0    0    auth_blocked_user_id_seq    SEQUENCE SET     D   SELECT pg_catalog.setval('auth.auth_blocked_user_id_seq', 9, true);
          auth          postgres    false    222         s           0    0    auth_permission_id_seq    SEQUENCE SET     D   SELECT pg_catalog.setval('auth.auth_permission_id_seq', 213, true);
          auth          postgres    false    224         t           0    0    auth_role_id_seq    SEQUENCE SET     <   SELECT pg_catalog.setval('auth.auth_role_id_seq', 4, true);
          auth          postgres    false    226         u           0    0    auth_user_id_seq    SEQUENCE SET     <   SELECT pg_catalog.setval('auth.auth_user_id_seq', 4, true);
          auth          postgres    false    229         v           0    0    organization_id_seq    SEQUENCE SET     G   SELECT pg_catalog.setval('organization.organization_id_seq', 4, true);
          organization          postgres    false    233         w           0    0    project_column_id_seq    SEQUENCE SET     D   SELECT pg_catalog.setval('project.project_column_id_seq', 3, true);
          project          postgres    false    236         x           0    0    project_id_seq    SEQUENCE SET     =   SELECT pg_catalog.setval('project.project_id_seq', 3, true);
          project          postgres    false    237         y           0    0    project_label_id_seq    SEQUENCE SET     C   SELECT pg_catalog.setval('project.project_label_id_seq', 9, true);
          project          postgres    false    239         z           0    0    project_member_id_seq    SEQUENCE SET     D   SELECT pg_catalog.setval('project.project_member_id_seq', 8, true);
          project          postgres    false    241         {           0    0    language_id_seq    SEQUENCE SET     ?   SELECT pg_catalog.setval('settings.language_id_seq', 3, true);
          settings          postgres    false    243         |           0    0    message_id_seq    SEQUENCE SET     >   SELECT pg_catalog.setval('settings.message_id_seq', 7, true);
          settings          postgres    false    245         }           0    0    message_translations_id_seq    SEQUENCE SET     L   SELECT pg_catalog.setval('settings.message_translations_id_seq', 10, true);
          settings          postgres    false    247         ~           0    0    settings_id_seq    SEQUENCE SET     ?   SELECT pg_catalog.setval('settings.settings_id_seq', 6, true);
          settings          postgres    false    249                    0    0    comment_id_seq    SEQUENCE SET     :   SELECT pg_catalog.setval('task.comment_id_seq', 2, true);
          task          postgres    false    251         ?           0    0    task_id_seq    SEQUENCE SET     7   SELECT pg_catalog.setval('task.task_id_seq', 2, true);
          task          postgres    false    253         ?           0    0    task_member_id_seq    SEQUENCE SET     >   SELECT pg_catalog.setval('task.task_member_id_seq', 2, true);
          task          postgres    false    255         |           2606    18606 (   auth_blocked_user auth_blocked_user_pkey 
   CONSTRAINT     d   ALTER TABLE ONLY auth.auth_blocked_user
    ADD CONSTRAINT auth_blocked_user_pkey PRIMARY KEY (id);
 P   ALTER TABLE ONLY auth.auth_blocked_user DROP CONSTRAINT auth_blocked_user_pkey;
       auth            postgres    false    221         ~           2606    18608 $   auth_permission auth_permission_pkey 
   CONSTRAINT     `   ALTER TABLE ONLY auth.auth_permission
    ADD CONSTRAINT auth_permission_pkey PRIMARY KEY (id);
 L   ALTER TABLE ONLY auth.auth_permission DROP CONSTRAINT auth_permission_pkey;
       auth            postgres    false    223         ?           2606    18610    auth_role auth_role_pkey 
   CONSTRAINT     T   ALTER TABLE ONLY auth.auth_role
    ADD CONSTRAINT auth_role_pkey PRIMARY KEY (id);
 @   ALTER TABLE ONLY auth.auth_role DROP CONSTRAINT auth_role_pkey;
       auth            postgres    false    225         ?           2606    18612    auth_user auth_user_email_key 
   CONSTRAINT     W   ALTER TABLE ONLY auth.auth_user
    ADD CONSTRAINT auth_user_email_key UNIQUE (email);
 E   ALTER TABLE ONLY auth.auth_user DROP CONSTRAINT auth_user_email_key;
       auth            postgres    false    228         ?           2606    18614    auth_user auth_user_phone_key 
   CONSTRAINT     W   ALTER TABLE ONLY auth.auth_user
    ADD CONSTRAINT auth_user_phone_key UNIQUE (phone);
 E   ALTER TABLE ONLY auth.auth_user DROP CONSTRAINT auth_user_phone_key;
       auth            postgres    false    228         ?           2606    18616    auth_user auth_user_pkey 
   CONSTRAINT     T   ALTER TABLE ONLY auth.auth_user
    ADD CONSTRAINT auth_user_pkey PRIMARY KEY (id);
 @   ALTER TABLE ONLY auth.auth_user DROP CONSTRAINT auth_user_pkey;
       auth            postgres    false    228         ?           2606    18618     auth_user auth_user_username_key 
   CONSTRAINT     ]   ALTER TABLE ONLY auth.auth_user
    ADD CONSTRAINT auth_user_username_key UNIQUE (username);
 H   ALTER TABLE ONLY auth.auth_user DROP CONSTRAINT auth_user_username_key;
       auth            postgres    false    228         ?           2606    18620 "   organization organization_name_key 
   CONSTRAINT     c   ALTER TABLE ONLY organization.organization
    ADD CONSTRAINT organization_name_key UNIQUE (name);
 R   ALTER TABLE ONLY organization.organization DROP CONSTRAINT organization_name_key;
       organization            postgres    false    232         ?           2606    18622    organization organization_pkey 
   CONSTRAINT     b   ALTER TABLE ONLY organization.organization
    ADD CONSTRAINT organization_pkey PRIMARY KEY (id);
 N   ALTER TABLE ONLY organization.organization DROP CONSTRAINT organization_pkey;
       organization            postgres    false    232         ?           2606    18624 "   project_column project_column_pkey 
   CONSTRAINT     a   ALTER TABLE ONLY project.project_column
    ADD CONSTRAINT project_column_pkey PRIMARY KEY (id);
 M   ALTER TABLE ONLY project.project_column DROP CONSTRAINT project_column_pkey;
       project            postgres    false    235         ?           2606    18626     project_label project_label_pkey 
   CONSTRAINT     _   ALTER TABLE ONLY project.project_label
    ADD CONSTRAINT project_label_pkey PRIMARY KEY (id);
 K   ALTER TABLE ONLY project.project_label DROP CONSTRAINT project_label_pkey;
       project            postgres    false    238         ?           2606    18628 "   project_member project_member_pkey 
   CONSTRAINT     a   ALTER TABLE ONLY project.project_member
    ADD CONSTRAINT project_member_pkey PRIMARY KEY (id);
 M   ALTER TABLE ONLY project.project_member DROP CONSTRAINT project_member_pkey;
       project            postgres    false    240         ?           2606    18630    project project_pkey 
   CONSTRAINT     S   ALTER TABLE ONLY project.project
    ADD CONSTRAINT project_pkey PRIMARY KEY (id);
 ?   ALTER TABLE ONLY project.project DROP CONSTRAINT project_pkey;
       project            postgres    false    234         ?           2606    18632    language language_code_key 
   CONSTRAINT     W   ALTER TABLE ONLY settings.language
    ADD CONSTRAINT language_code_key UNIQUE (code);
 F   ALTER TABLE ONLY settings.language DROP CONSTRAINT language_code_key;
       settings            postgres    false    242         ?           2606    18634    language language_pkey 
   CONSTRAINT     V   ALTER TABLE ONLY settings.language
    ADD CONSTRAINT language_pkey PRIMARY KEY (id);
 B   ALTER TABLE ONLY settings.language DROP CONSTRAINT language_pkey;
       settings            postgres    false    242         ?           2606    18636    message message_code_key 
   CONSTRAINT     U   ALTER TABLE ONLY settings.message
    ADD CONSTRAINT message_code_key UNIQUE (code);
 D   ALTER TABLE ONLY settings.message DROP CONSTRAINT message_code_key;
       settings            postgres    false    244         ?           2606    18638    message message_pkey 
   CONSTRAINT     T   ALTER TABLE ONLY settings.message
    ADD CONSTRAINT message_pkey PRIMARY KEY (id);
 @   ALTER TABLE ONLY settings.message DROP CONSTRAINT message_pkey;
       settings            postgres    false    244         ?           2606    18640 .   message_translations message_translations_pkey 
   CONSTRAINT     n   ALTER TABLE ONLY settings.message_translations
    ADD CONSTRAINT message_translations_pkey PRIMARY KEY (id);
 Z   ALTER TABLE ONLY settings.message_translations DROP CONSTRAINT message_translations_pkey;
       settings            postgres    false    246         ?           2606    18642    settings settings_pkey 
   CONSTRAINT     V   ALTER TABLE ONLY settings.settings
    ADD CONSTRAINT settings_pkey PRIMARY KEY (id);
 B   ALTER TABLE ONLY settings.settings DROP CONSTRAINT settings_pkey;
       settings            postgres    false    248         ?           2606    18644    comment comment_pkey 
   CONSTRAINT     P   ALTER TABLE ONLY task.comment
    ADD CONSTRAINT comment_pkey PRIMARY KEY (id);
 <   ALTER TABLE ONLY task.comment DROP CONSTRAINT comment_pkey;
       task            postgres    false    250         ?           2606    18646    task_member task_member_pkey 
   CONSTRAINT     X   ALTER TABLE ONLY task.task_member
    ADD CONSTRAINT task_member_pkey PRIMARY KEY (id);
 D   ALTER TABLE ONLY task.task_member DROP CONSTRAINT task_member_pkey;
       task            postgres    false    254         ?           2606    18648    task task_pkey 
   CONSTRAINT     J   ALTER TABLE ONLY task.task
    ADD CONSTRAINT task_pkey PRIMARY KEY (id);
 6   ALTER TABLE ONLY task.task DROP CONSTRAINT task_pkey;
       task            postgres    false    252         ?           2606    18649 3   auth_blocked_user auth_blocked_user_message_code_fk    FK CONSTRAINT     ?   ALTER TABLE ONLY auth.auth_blocked_user
    ADD CONSTRAINT auth_blocked_user_message_code_fk FOREIGN KEY (blocked_for) REFERENCES settings.message(code);
 [   ALTER TABLE ONLY auth.auth_blocked_user DROP CONSTRAINT auth_blocked_user_message_code_fk;
       auth          postgres    false    3226    244    221         ?           2606    18654 <   auth_role_permission auth_role_permission_permission_id_fkey    FK CONSTRAINT     ?   ALTER TABLE ONLY auth.auth_role_permission
    ADD CONSTRAINT auth_role_permission_permission_id_fkey FOREIGN KEY (permission_id) REFERENCES auth.auth_permission(id);
 d   ALTER TABLE ONLY auth.auth_role_permission DROP CONSTRAINT auth_role_permission_permission_id_fkey;
       auth          postgres    false    223    227    3198         ?           2606    18659 6   auth_role_permission auth_role_permission_role_id_fkey    FK CONSTRAINT     ?   ALTER TABLE ONLY auth.auth_role_permission
    ADD CONSTRAINT auth_role_permission_role_id_fkey FOREIGN KEY (role_id) REFERENCES auth.auth_role(id);
 ^   ALTER TABLE ONLY auth.auth_role_permission DROP CONSTRAINT auth_role_permission_role_id_fkey;
       auth          postgres    false    3200    225    227         ?           2606    18664 <   auth_user_permission auth_user_permission_permission_id_fkey    FK CONSTRAINT     ?   ALTER TABLE ONLY auth.auth_user_permission
    ADD CONSTRAINT auth_user_permission_permission_id_fkey FOREIGN KEY (permission_id) REFERENCES auth.auth_permission(id);
 d   ALTER TABLE ONLY auth.auth_user_permission DROP CONSTRAINT auth_user_permission_permission_id_fkey;
       auth          postgres    false    230    223    3198         ?           2606    18669 6   auth_user_permission auth_user_permission_user_id_fkey    FK CONSTRAINT     ?   ALTER TABLE ONLY auth.auth_user_permission
    ADD CONSTRAINT auth_user_permission_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.auth_user(id);
 ^   ALTER TABLE ONLY auth.auth_user_permission DROP CONSTRAINT auth_user_permission_user_id_fkey;
       auth          postgres    false    230    3206    228         ?           2606    18674 *   auth_user_role auth_user_role_role_id_fkey    FK CONSTRAINT     ?   ALTER TABLE ONLY auth.auth_user_role
    ADD CONSTRAINT auth_user_role_role_id_fkey FOREIGN KEY (role_id) REFERENCES auth.auth_role(id);
 R   ALTER TABLE ONLY auth.auth_user_role DROP CONSTRAINT auth_user_role_role_id_fkey;
       auth          postgres    false    225    231    3200         ?           2606    18679 *   auth_user_role auth_user_role_user_id_fkey    FK CONSTRAINT     ?   ALTER TABLE ONLY auth.auth_user_role
    ADD CONSTRAINT auth_user_role_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.auth_user(id);
 R   ALTER TABLE ONLY auth.auth_user_role DROP CONSTRAINT auth_user_role_user_id_fkey;
       auth          postgres    false    3206    231    228         ?           2606    18684 -   project_column project_column_project_id_fkey    FK CONSTRAINT     ?   ALTER TABLE ONLY project.project_column
    ADD CONSTRAINT project_column_project_id_fkey FOREIGN KEY (project_id) REFERENCES project.project(id);
 X   ALTER TABLE ONLY project.project_column DROP CONSTRAINT project_column_project_id_fkey;
       project          postgres    false    234    235    3214         ?           2606    18689 -   project_member project_member_project_id_fkey    FK CONSTRAINT     ?   ALTER TABLE ONLY project.project_member
    ADD CONSTRAINT project_member_project_id_fkey FOREIGN KEY (project_id) REFERENCES project.project(id);
 X   ALTER TABLE ONLY project.project_member DROP CONSTRAINT project_member_project_id_fkey;
       project          postgres    false    240    3214    234         ?           2606    18694 *   project_member project_member_user_id_fkey    FK CONSTRAINT     ?   ALTER TABLE ONLY project.project_member
    ADD CONSTRAINT project_member_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.auth_user(id);
 U   ALTER TABLE ONLY project.project_member DROP CONSTRAINT project_member_user_id_fkey;
       project          postgres    false    240    3206    228         ?           2606    18699 $   project project_organization_id_fkey    FK CONSTRAINT     ?   ALTER TABLE ONLY project.project
    ADD CONSTRAINT project_organization_id_fkey FOREIGN KEY (organization_id) REFERENCES organization.organization(id);
 O   ALTER TABLE ONLY project.project DROP CONSTRAINT project_organization_id_fkey;
       project          postgres    false    232    3212    234         ?           2606    18704 :   message_translations message_translations_language_code_fk    FK CONSTRAINT     ?   ALTER TABLE ONLY settings.message_translations
    ADD CONSTRAINT message_translations_language_code_fk FOREIGN KEY (language) REFERENCES settings.language(code);
 f   ALTER TABLE ONLY settings.message_translations DROP CONSTRAINT message_translations_language_code_fk;
       settings          postgres    false    246    3222    242         ?           2606    18709 9   message_translations message_translations_message_code_fk    FK CONSTRAINT     ?   ALTER TABLE ONLY settings.message_translations
    ADD CONSTRAINT message_translations_message_code_fk FOREIGN KEY (message) REFERENCES settings.message(code);
 e   ALTER TABLE ONLY settings.message_translations DROP CONSTRAINT message_translations_message_code_fk;
       settings          postgres    false    3226    244    246         ?           2606    18714    comment comment_task_id_fkey    FK CONSTRAINT     v   ALTER TABLE ONLY task.comment
    ADD CONSTRAINT comment_task_id_fkey FOREIGN KEY (task_id) REFERENCES task.task(id);
 D   ALTER TABLE ONLY task.comment DROP CONSTRAINT comment_task_id_fkey;
       task          postgres    false    252    3236    250         ?           2606    18719 $   task_member task_member_task_id_fkey    FK CONSTRAINT     ~   ALTER TABLE ONLY task.task_member
    ADD CONSTRAINT task_member_task_id_fkey FOREIGN KEY (task_id) REFERENCES task.task(id);
 L   ALTER TABLE ONLY task.task_member DROP CONSTRAINT task_member_task_id_fkey;
       task          postgres    false    3236    254    252         ?           2606    18724 $   task_member task_member_user_id_fkey    FK CONSTRAINT     ?   ALTER TABLE ONLY task.task_member
    ADD CONSTRAINT task_member_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.auth_user(id);
 L   ALTER TABLE ONLY task.task_member DROP CONSTRAINT task_member_user_id_fkey;
       task          postgres    false    3206    254    228         ?           2606    18729     task task_project_column_id_fkey    FK CONSTRAINT     ?   ALTER TABLE ONLY task.task
    ADD CONSTRAINT task_project_column_id_fkey FOREIGN KEY (project_column_id) REFERENCES project.project_column(id);
 H   ALTER TABLE ONLY task.task DROP CONSTRAINT task_project_column_id_fkey;
       task          postgres    false    235    3216    252                                          3386.dat                                                                                            0000600 0004000 0002000 00000000116 14172533476 0014267 0                                                                                                    ustar 00postgres                        postgres                        0000000 0000000                                                                                                                                                                        9	4	BAD_CONTENT	2022-01-21 16:32:54.327309+05	2022-01-22 16:32:54+05	2	f
\.


                                                                                                                                                                                                                                                                                                                                                                                                                                                  3388.dat                                                                                            0000600 0004000 0002000 00000004215 14172533476 0014275 0                                                                                                    ustar 00postgres                        postgres                        0000000 0000000                                                                                                                                                                        199	TASK_CHANGE_ORDER	task change order
167	COMMENT_GET_LIST	comment get list
161	COLUMN_GET_DETAILS	column get details
175	ORGANIZATION_CHANGE_STATUS	organization change status
196	PROJECT_UPDATE	project update
170	EMPLOYEE_CREATE	employee create
181	ORGANIZATION_UNBLOCK	organization unblock
168	COMMENT_UPDATE	comment update
156	ADMIN_UPDATE	admin update
186	PROJECT_BLOCK	project block
178	ORGANIZATION_GET	organization get
152	ADMIN_BLOCK	admin block
176	ORGANIZATION_CREATE	organization create
158	COLUMN_CREATE	column create
198	TASK_ADD_MEMBER	task add member
197	ROLE_SET	role set
164	COMMENT_CREATE	comment create
194	PROJECT_UNARCHIVE	project unarchive
166	COMMENT_GET	comment get
180	ORGANIZATION_GET_LIST	organization get list
163	COLUMN_UPDATE	column update
159	COLUMN_DELETE	column delete
182	ORGANIZATION_UPDATE	organization update
184	PROJECT_ADD_MEMBER	project add member
154	ADMIN_DELETE	admin delete
160	COLUMN_GET	column get
183	PERMISSION_SET	permission set
155	ADMIN_UNBLOCK	admin unblock
190	PROJECT_GET_DETAILS	project get details
177	ORGANIZATION_DELETE	organization delete
187	PROJECT_CREATE	project create
192	PROJECT_GET_LIST	project get list
162	COLUMN_GET_LIST	column get list
174	ORGANIZATION_BLOCK	organization block
173	EMPLOYEE_UPDATE	employee update
200	TASK_CREATE	task create
157	COLUMN_CHANGE_ORDER	column change order
153	ADMIN_CREATE	admin create
188	PROJECT_DELETE	project delete
171	EMPLOYEE_DELETE	employee delete
172	EMPLOYEE_UNBLOCK	employee unblock
191	PROJECT_GET_LEAD	project get lead
195	PROJECT_UNBLOCK	project unblock
189	PROJECT_GET	project get
169	EMPLOYEE_BLOCK	employee block
179	ORGANIZATION_GET_DETAILS	organization get details
185	PROJECT_ARCHIVE	project archive
193	PROJECT_REMOVE_MEMBER	project remove member
165	COMMENT_DELETE	comment delete
211	USER_GET_LIST	user get list
206	TASK_UPDATE	task update
209	USER_DELETE	user delete
203	TASK_GET_DETAILS	task get details
212	USER_INFO	user info
213	USER_UNBLOCK	user unblock
201	TASK_DELETE	task delete
210	USER_GET	user get
208	USER_CREATE	user create
204	TASK_GET_LIST	task get list
202	TASK_GET	task get
205	TASK_REMOVE_MEMBER	task remove member
207	USER_BLOCK	user block
\.


                                                                                                                                                                                                                                                                                                                                                                                   3390.dat                                                                                            0000600 0004000 0002000 00000000133 14172533476 0014261 0                                                                                                    ustar 00postgres                        postgres                        0000000 0000000                                                                                                                                                                        1	ADMIN	Admin	100
4	EMPLOYEE	Employee	10
2	HR	Human Resources	80
3	MANAGER	Manager	50
\.


                                                                                                                                                                                                                                                                                                                                                                                                                                     3392.dat                                                                                            0000600 0004000 0002000 00000000005 14172533476 0014261 0                                                                                                    ustar 00postgres                        postgres                        0000000 0000000                                                                                                                                                                        \.


                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           3393.dat                                                                                            0000600 0004000 0002000 00000001145 14172533476 0014270 0                                                                                                    ustar 00postgres                        postgres                        0000000 0000000                                                                                                                                                                        2	$2a$04$h6Emo5deCpU8V4AyyTli5.1tLkSPg5g7UD1BzEuoBJu9fvnyjDa2u	72d87693-1a99-4190-acf1-1470a16ab36d	hello@gmail.com	998908115225	hello	HELLO	t	\N	1	1	0	RU	f	2022-01-15 12:55:27.434833+05	-1	\N	\N	hello
4	$2a$04$ufO1Wgz.RO.fVOm/0qqP4u8Eaj9fUaNmn8T/kwQeemFR78OYH8QC.	3d2bf9c2-63e9-4678-9789-36ef6e30e51d	doston@gmail.com	998946812030	Admin	Super	f	\N	0	2	0	EN	f	2022-01-19 00:12:35.909235+05	2	\N	\N	admin
3	$2a$04$mmKOK8JWCDp2zH2qRMyVf.vzGI3aL9ylbWcTExgB2WjrpekjRFq3a	1e671bfb-1662-4978-94bc-2749beee4362	hello2@gmail.com	998908115224	hello	HELLO	t	\N	0	1	0	EN	t	2022-01-15 15:33:39.179607+05	2	\N	\N	john123
\.


                                                                                                                                                                                                                                                                                                                                                                                                                           3395.dat                                                                                            0000600 0004000 0002000 00000000571 14172533476 0014274 0                                                                                                    ustar 00postgres                        postgres                        0000000 0000000                                                                                                                                                                        2	152
2	153
2	154
2	155
2	156
2	157
2	158
2	159
2	160
2	161
2	162
2	163
2	164
2	165
2	166
2	167
2	168
2	169
2	170
2	171
2	172
2	173
2	174
2	175
2	176
2	177
2	178
2	179
2	180
2	181
2	182
2	183
2	184
2	185
2	186
2	187
2	188
2	189
2	190
2	191
2	192
2	193
2	194
2	195
2	196
2	197
2	198
2	199
2	200
2	201
2	202
2	203
2	204
2	205
2	206
2	207
2	208
2	209
2	210
2	211
2	212
2	213
\.


                                                                                                                                       3396.dat                                                                                            0000600 0004000 0002000 00000000015 14172533476 0014266 0                                                                                                    ustar 00postgres                        postgres                        0000000 0000000                                                                                                                                                                        2	1
3	1
\.


                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   3397.dat                                                                                            0000600 0004000 0002000 00000000633 14172533476 0014275 0                                                                                                    ustar 00postgres                        postgres                        0000000 0000000                                                                                                                                                                        1	PDP	\N	\N	\N	1405770371	0	2022-02-15 12:05:41.277956+05	(2,3)	2022-01-15 12:05:41.277956+05	\N	f
2	MVP	\N	\N	\N	1654351	0	2023-01-17 17:21:05.915114+05	(2,3)	2022-01-17 17:21:05.915114+05	2	f
3	kl]	\N	\N	\N	123	0	2023-01-21 15:11:24.835284+05	(2,3)	2022-01-21 15:11:24.835284+05	2	f
4	jk]	sdfsdfdsf	asdasd@gmail.com	12312asdfsd	123	0	2023-01-21 15:11:56.152929+05	(0,0)	2022-01-21 15:11:56.152929+05	2	f
\.


                                                                                                     3399.dat                                                                                            0000600 0004000 0002000 00000000667 14172533476 0014306 0                                                                                                    ustar 00postgres                        postgres                        0000000 0000000                                                                                                                                                                        1	test1	1100b25e-9cc3-4f8e-add6-dc982c683be7	https://pdp.uz	f	https://helloworld.com	test1 description	1	f	2022-01-15 16:54:59.652357+05	2	\N	\N	0
2	BOOM project	9ae8b3b0-083a-474d-a2db-cd70abcb5c91	grey	f	about.com	alsdjhkek lksdjfh sadkl;jfhasdfwe	1	f	2022-01-21 17:07:59.763009+05	2	\N	\N	0
3	BOOM PROJECT	57580389-4f9c-4182-8707-18f553169291	grey	f	lasdlk.com	bu shunchaki test project	1	f	2022-01-21 17:09:28.080656+05	2	\N	\N	0
\.


                                                                         3400.dat                                                                                            0000600 0004000 0002000 00000000174 14172533476 0014256 0                                                                                                    ustar 00postgres                        postgres                        0000000 0000000                                                                                                                                                                        2	To do	\N	1	1	t	2022-01-15 16:55:39.506569+05	1	\N	\N
3	TODO BOOM	SHARMAS	3	1	f	2022-01-21 17:29:03.451347+05	2	\N	\N
\.


                                                                                                                                                                                                                                                                                                                                                                                                    3403.dat                                                                                            0000600 0004000 0002000 00000000711 14172533476 0014256 0                                                                                                    ustar 00postgres                        postgres                        0000000 0000000                                                                                                                                                                        2	\N	88AA8BFF	\N	f	2022-01-16 09:34:17.214794+05	2	\N	\N
3	\N	21AF27FF	\N	f	2022-01-16 09:34:17.214794+05	2	\N	\N
4	\N	1969C1FF	\N	f	2022-01-16 09:34:17.214794+05	2	\N	\N
5	\N	CD091FFF	\N	f	2022-01-16 09:34:17.214794+05	2	\N	\N
9	\N	CD091FFF	1	t	2022-01-16 09:34:59.117429+05	2	\N	\N
6	\N	88AA8BFF	1	t	2022-01-16 09:34:59.117429+05	2	\N	\N
7	\N	21AF27FF	1	t	2022-01-16 09:34:59.117429+05	2	\N	\N
8	\N	1969C1FF	1	t	2022-01-16 09:34:59.117429+05	2	\N	\N
\.


                                                       3405.dat                                                                                            0000600 0004000 0002000 00000000225 14172533476 0014260 0                                                                                                    ustar 00postgres                        postgres                        0000000 0000000                                                                                                                                                                        6	1	3	f	t	2022-01-18 23:22:32.839351+05	3	\N	\N
7	2	2	t	f	2022-01-21 17:07:59.763009+05	2	\N	\N
8	3	2	t	f	2022-01-21 17:09:28.080656+05	2	\N	\N
\.


                                                                                                                                                                                                                                                                                                                                                                           3407.dat                                                                                            0000600 0004000 0002000 00000000052 14172533476 0014260 0                                                                                                    ustar 00postgres                        postgres                        0000000 0000000                                                                                                                                                                        1	Uzbek	UZ
2	Russian	RU
3	English	EN
\.


                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      3409.dat                                                                                            0000600 0004000 0002000 00000000475 14172533476 0014273 0                                                                                                    ustar 00postgres                        postgres                        0000000 0000000                                                                                                                                                                        2	ERROR_LOGIN_TRY_COUNT	f	2022-01-15 14:26:23.109793+05	1	\N	\N
3	INTERNAL_SERVER_ERROR	f	2022-01-15 14:32:39.445022+05	1	\N	\N
5	PROJECT_CODE_IS_ALREADY_TAKEN	f	2022-01-15 15:48:25.557894+05	1	\N	\N
6	BAD_CREDENTIALS	f	2022-01-16 12:40:28.855911+05	1	\N	\N
7	BAD_CONTENT	f	2022-01-21 15:37:47.709681+05	1	\N	\N
\.


                                                                                                                                                                                                   3411.dat                                                                                            0000600 0004000 0002000 00000000552 14172533476 0014260 0                                                                                                    ustar 00postgres                        postgres                        0000000 0000000                                                                                                                                                                        5	ERROR_LOGIN_TRY_COUNT	UZ	Ko'p urunishlar uchun blocklanging
6	ERROR_LOGIN_TRY_COUNT	RU	Блокировка за несколько попыток
7	ERROR_LOGIN_TRY_COUNT	EN	Blocking for multiple attempts
8	BAD_CREDENTIALS	UZ	Xatoliklar bor ekan 😂
9	BAD_CREDENTIALS	RU	Неверные учётные данные
10	BAD_CREDENTIALS	EN	Bad Credentials
\.


                                                                                                                                                      3413.dat                                                                                            0000600 0004000 0002000 00000000175 14172533476 0014263 0                                                                                                    ustar 00postgres                        postgres                        0000000 0000000                                                                                                                                                                        1	TASK_LEVEL	EASY
2	TASK_LEVEL	MEDIUM
3	TASK_LEVEL	HARD
4	TASK_PRIORITY	LOW
5	TASK_PRIORITY	MEDIUM
6	TASK_PRIORITY	HIGH
\.


                                                                                                                                                                                                                                                                                                                                                                                                   3415.dat                                                                                            0000600 0004000 0002000 00000000005 14172533476 0014255 0                                                                                                    ustar 00postgres                        postgres                        0000000 0000000                                                                                                                                                                        \.


                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           3417.dat                                                                                            0000600 0004000 0002000 00000000133 14172533476 0014261 0                                                                                                    ustar 00postgres                        postgres                        0000000 0000000                                                                                                                                                                        2	test	test	2	2022-01-15 21:55:55.701+05	1	1	4	t	2022-01-15 16:56:11.65531+05	2	\N	\N
\.


                                                                                                                                                                                                                                                                                                                                                                                                                                     3419.dat                                                                                            0000600 0004000 0002000 00000000140 14172533476 0014261 0                                                                                                    ustar 00postgres                        postgres                        0000000 0000000                                                                                                                                                                        1	2	2	t	2022-01-15 22:53:17.34417+05	2	\N	\N
2	3	2	t	2022-01-15 22:53:27.423678+05	2	\N	\N
\.


                                                                                                                                                                                                                                                                                                                                                                                                                                restore.sql                                                                                         0000600 0004000 0002000 00000357271 14172533476 0015417 0                                                                                                    ustar 00postgres                        postgres                        0000000 0000000                                                                                                                                                                        --
-- NOTE:
--
-- File paths need to be edited. Search for $$PATH$$ and
-- replace it with the path to the directory containing
-- the extracted data files.
--
--
-- PostgreSQL database dump
--

-- Dumped from database version 13.5
-- Dumped by pg_dump version 13.5

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

DROP DATABASE trello_version_3;
--
-- Name: trello_version_3; Type: DATABASE; Schema: -; Owner: postgres
--

CREATE DATABASE trello_version_3 WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE = 'English_United States.1251';


ALTER DATABASE trello_version_3 OWNER TO postgres;

\connect trello_version_3

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: auth; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA auth;


ALTER SCHEMA auth OWNER TO postgres;

--
-- Name: buildins; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA buildins;


ALTER SCHEMA buildins OWNER TO postgres;

--
-- Name: checks; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA checks;


ALTER SCHEMA checks OWNER TO postgres;

--
-- Name: mappers; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA mappers;


ALTER SCHEMA mappers OWNER TO postgres;

--
-- Name: organization; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA organization;


ALTER SCHEMA organization OWNER TO postgres;

--
-- Name: permission; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA permission;


ALTER SCHEMA permission OWNER TO postgres;

--
-- Name: project; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA project;


ALTER SCHEMA project OWNER TO postgres;

--
-- Name: settings; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA settings;


ALTER SCHEMA settings OWNER TO postgres;

--
-- Name: task; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA task;


ALTER SCHEMA task OWNER TO postgres;

--
-- Name: utils; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA utils;


ALTER SCHEMA utils OWNER TO postgres;

--
-- Name: pgcrypto; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pgcrypto WITH SCHEMA buildins;


--
-- Name: EXTENSION pgcrypto; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION pgcrypto IS 'cryptographic functions';


--
-- Name: auth_user_block_dto; Type: TYPE; Schema: auth; Owner: postgres
--

CREATE TYPE auth.auth_user_block_dto AS (
	userid bigint,
	block_for character varying,
	block_till character varying
);


ALTER TYPE auth.auth_user_block_dto OWNER TO postgres;

--
-- Name: auth_user_create_dto; Type: TYPE; Schema: auth; Owner: postgres
--

CREATE TYPE auth.auth_user_create_dto AS (
	username character varying,
	email character varying,
	phone character varying,
	password character varying,
	organization_id bigint,
	first_name character varying,
	language character varying,
	last_name character varying
);


ALTER TYPE auth.auth_user_create_dto OWNER TO postgres;

--
-- Name: organization_create_dto; Type: TYPE; Schema: organization; Owner: postgres
--

CREATE TYPE organization.organization_create_dto AS (
	name character varying,
	website character varying,
	email character varying,
	logo character varying,
	reg_number character varying,
	location point
);


ALTER TYPE organization.organization_create_dto OWNER TO postgres;

--
-- Name: organization_update_dto; Type: TYPE; Schema: organization; Owner: postgres
--

CREATE TYPE organization.organization_update_dto AS (
	id bigint,
	website character varying,
	email character varying,
	logo character varying,
	location point
);


ALTER TYPE organization.organization_update_dto OWNER TO postgres;

--
-- Name: permission_set_dto; Type: TYPE; Schema: permission; Owner: postgres
--

CREATE TYPE permission.permission_set_dto AS (
	id bigint,
	permission bigint
);


ALTER TYPE permission.permission_set_dto OWNER TO postgres;

--
-- Name: column_create_dto; Type: TYPE; Schema: project; Owner: postgres
--

CREATE TYPE project.column_create_dto AS (
	name character varying,
	project_id bigint,
	"order" smallint,
	emoji character varying
);


ALTER TYPE project.column_create_dto OWNER TO postgres;

--
-- Name: column_update_dto; Type: TYPE; Schema: project; Owner: postgres
--

CREATE TYPE project.column_update_dto AS (
	name character varying,
	emoji character varying,
	"order" smallint,
	column_id bigint
);


ALTER TYPE project.column_update_dto OWNER TO postgres;

--
-- Name: project_create_dto; Type: TYPE; Schema: project; Owner: postgres
--

CREATE TYPE project.project_create_dto AS (
	name character varying,
	tz character varying,
	description text,
	background character varying,
	organization_id bigint
);


ALTER TYPE project.project_create_dto OWNER TO postgres;

--
-- Name: project_update_dto; Type: TYPE; Schema: project; Owner: postgres
--

CREATE TYPE project.project_update_dto AS (
	id bigint,
	name character varying,
	tz character varying,
	description text,
	background character varying,
	organization_id bigint
);


ALTER TYPE project.project_update_dto OWNER TO postgres;

--
-- Name: task_add_comment_dto; Type: TYPE; Schema: task; Owner: postgres
--

CREATE TYPE task.task_add_comment_dto AS (
	message text,
	task_id bigint
);


ALTER TYPE task.task_add_comment_dto OWNER TO postgres;

--
-- Name: task_create_dto; Type: TYPE; Schema: task; Owner: postgres
--

CREATE TYPE task.task_create_dto AS (
	name character varying,
	description text,
	project_column_id bigint,
	deadline timestamp without time zone,
	"order" smallint,
	level bigint,
	priority bigint
);


ALTER TYPE task.task_create_dto OWNER TO postgres;

--
-- Name: task_update_dto; Type: TYPE; Schema: task; Owner: postgres
--

CREATE TYPE task.task_update_dto AS (
	id bigint,
	name character varying,
	description text,
	project_column_id bigint,
	deadline timestamp with time zone,
	"order" smallint,
	level bigint,
	priority bigint
);


ALTER TYPE task.task_update_dto OWNER TO postgres;

--
-- Name: auth_user_info(bigint); Type: FUNCTION; Schema: auth; Owner: postgres
--

CREATE FUNCTION auth.auth_user_info(userid bigint) RETURNS text
    LANGUAGE plpgsql
    AS $$
declare
begin
    return json_agg((select row_to_json("table")
                     from (select au.id,
                                  au.code,
                                  au.username userName,
                                  au.first_name firstName,
                                  au.last_name  lastName,
                                  au.phone,
                                  au.email,
                                  au.language
                           from auth.auth_user au
                           where au.id = userid) "table"));
end
$$;


ALTER FUNCTION auth.auth_user_info(userid bigint) OWNER TO postgres;

--
-- Name: block_user(text, bigint); Type: FUNCTION; Schema: auth; Owner: postgres
--

CREATE FUNCTION auth.block_user(dataparam text, userid bigint) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
DECLARE
    dto       auth.auth_user_block_dto;
    t_mem     auth.auth_user%rowtype;
    t_auth    auth.auth_user%rowtype;
    t_block_u auth.auth_blocked_user%rowtype;
begin

    call utils.check_data(dataparam);

    dto = mappers.to_user_block_dto(dataparam::json);

    select * into t_mem from auth.auth_user where id = dto.userid;

    t_auth = auth.is_active(userid);
    if not (auth.hasanyrole('ADMIN#HR', userid) or t_auth.is_super_user or
            t_auth.organization_id = t_mem.organization_id) then
        raise exception 'PERMISSION_DENIED';
    end if;

    if exists(select
              from auth.auth_blocked_user bl
              where bl.user_id = t_mem.id
                and not bl.is_deleted) then
        raise exception 'USER_ALREADY_BLOCKED';
    end if;

    if t_mem.is_deleted or not FOUND then
        raise exception 'USER_NOT_FOUND';
    end if;

    insert into auth.auth_blocked_user (user_id, blocked_by, blocked_for, blocked_till)
    values (dto.userid, userid, dto.block_for, to_timestamp(dto.block_till, 'YYYY-MM-DD HH24:MI:SS'));

    return true;
end
$$;


ALTER FUNCTION auth.block_user(dataparam text, userid bigint) OWNER TO postgres;

--
-- Name: create_user(text, bigint); Type: FUNCTION; Schema: auth; Owner: postgres
--

CREATE FUNCTION auth.create_user(dataparam text, userid bigint) RETURNS bigint
    LANGUAGE plpgsql
    AS $$
declare
    t_session_user auth.auth_user%rowtype;
    dto            auth.auth_user_create_dto;
    new_id         bigint;
begin
    t_session_user = auth.is_active(userid);
    if not (auth.hasAnyRole('ADMIN#HR', userid) or t_session_user.is_super_user) then
        raise exception '%',utils.error_message('PERMISSION_DENIED', t_session_user.language);
    end if;

    call utils.check_data(data := dataparam);
    dto = mappers.to_auth_user_create_dto(dataparam::json);
    dto = checks.check_auth_user_create_dto(dto);

    if not (t_session_user.is_super_user or t_session_user.organization_id = dto.organization_id) then
        raise exception 'PERMISSION_DENIED';
    end if;

    insert into auth.auth_user (password, email, phone, first_name, last_name, organization_id, status, language,
                                created_by, username)
    values (utils.encode_password(dto.password), dto.email, dto.phone, dto.first_name, dto.last_name,
            dto.organization_id, 0, dto.language,
            userid, dto.username)
    returning id into new_id;
    return new_id;
end
$$;


ALTER FUNCTION auth.create_user(dataparam text, userid bigint) OWNER TO postgres;

--
-- Name: delete_user(bigint, bigint); Type: FUNCTION; Schema: auth; Owner: postgres
--

CREATE FUNCTION auth.delete_user(target_userid bigint, userid bigint) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
DECLARE
    t_mem  auth.auth_user%rowtype;
    t_auth auth.auth_user%rowtype;
begin
    --     t_mem = auth.is_active(target_userid);'
    t_auth = auth.is_active(userid);
    select * into t_mem from auth.auth_user where id = target_userid and not is_deleted;
    if not FOUND then
        raise exception 'USER_NOT_FOUND';
    end if;

    if not (auth.hasanyrole('ADMIN#HR', userid) or t_auth.is_super_user or
            t_auth.organization_id = t_mem.organization_id) then
        raise exception 'PERMISSION_DENIED';
    end if;

    if t_mem.is_deleted then
        raise exception 'USER_NOT_FOUND';
    end if;

    update auth.auth_user set is_deleted = true where id = target_userid;
    return true;
end
$$;


ALTER FUNCTION auth.delete_user(target_userid bigint, userid bigint) OWNER TO postgres;

--
-- Name: get_project_id(bigint); Type: FUNCTION; Schema: auth; Owner: postgres
--

CREATE FUNCTION auth.get_project_id(userid bigint) RETURNS bigint
    LANGUAGE plpgsql
    AS $$
declare
    v_id int8;
begin
    select project_id into v_id from project.project_member where user_id =userid ;
    return v_id;
end
$$;


ALTER FUNCTION auth.get_project_id(userid bigint) OWNER TO postgres;

--
-- Name: hasanypermission(character varying, bigint); Type: FUNCTION; Schema: auth; Owner: postgres
--

CREATE FUNCTION auth.hasanypermission(permissions character varying, userid bigint) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
begin
    return exists(select ap.id
                  from auth.auth_permission ap
                           inner join auth.auth_user_permission arp on ap.id = arp.permission_id
                  where arp.user_id = userid
                    and ap.code = any (string_to_array(permissions, '#')));
end
$$;


ALTER FUNCTION auth.hasanypermission(permissions character varying, userid bigint) OWNER TO postgres;

--
-- Name: hasanyrole(character varying, bigint); Type: FUNCTION; Schema: auth; Owner: postgres
--

CREATE FUNCTION auth.hasanyrole(roles character varying, userid bigint) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
begin
    return exists(select *
                  from auth.auth_user_role aur
                  where aur.user_id = userid
                    and aur.role_id in (select id
                                        from auth.auth_role
                                        where code = any (string_to_array(roles, '#'))));
end
$$;


ALTER FUNCTION auth.hasanyrole(roles character varying, userid bigint) OWNER TO postgres;

--
-- Name: is_active(bigint); Type: FUNCTION; Schema: auth; Owner: postgres
--

CREATE FUNCTION auth.is_active(v_user_id bigint) RETURNS record
    LANGUAGE plpgsql
    AS $$
declare
    t_auth_user    auth.auth_user%rowtype;
    t_organization organization.organization%rowtype;
    t_block_user   auth.auth_blocked_user%rowtype;
BEGIN
    select * into t_auth_user from auth.auth_user where not is_deleted and id = v_user_id;
    if not FOUND then
        raise exception 'USER_NOT_FOUND';
    end if;

    if t_auth_user.status <> 0 then
        raise exception 'USER_NOT_ACTIVE';
    end if;
    select *
    into t_block_user
    from auth.auth_blocked_user ab
    where not is_deleted
      and ab.user_id = v_user_id
    order by ab.blocked_till desc
    limit 1;

    if FOUND then
        raise exception 'USER_BLOCKED';
    end if;

    select *
    into t_organization
    from organization.organization o
    where not o.is_deleted
      and o.id = t_auth_user.organization_id;

    if not FOUND then
        raise exception 'ORGANIZATION_NOT_FOUND';
    end if;

    if t_organization.paid_for <= current_timestamp or t_organization.status <> 0 then
        raise exception 'ORGANIZATION_NOT_ACTIVE';
    end if;

    return t_auth_user;
END;
$$;


ALTER FUNCTION auth.is_active(v_user_id bigint) OWNER TO postgres;

--
-- Name: login(character varying, character varying, text); Type: PROCEDURE; Schema: auth; Owner: postgres
--

CREATE PROCEDURE auth.login(uname character varying, pswd character varying, INOUT _out text DEFAULT NULL::text)
    LANGUAGE plpgsql
    AS $$
declare
    t_auth_user         record;
    t_auth_blocked_user record;
    t_organization      organization.organization%rowtype;
    response            jsonb;
    v_login_try_count   smallint;
    v_state             varchar;
    v_msg               varchar;
    v_detail            varchar;
    v_hint              varchar;
    v_context           varchar;
begin
    select * into t_auth_user from auth.auth_user where not is_deleted and username ilike uname;

    IF NOT FOUND then
        raise exception '%',utils.error_message('BAD_CREDENTIALS');
    END IF;

    select *
    into t_auth_blocked_user
    from auth.auth_blocked_user abu
    where not abu.is_deleted
      and abu.user_id = t_auth_user.id
    order by abu.blocked_till desc
    limit 1;

    if FOUND then
        raise exception '%',utils.error_message(t_auth_blocked_user.blocked_for);
    end if;

    if t_auth_user.status <> 0 then
        raise exception 'USER_NOT_ACTIVE';
    end if;

    if not utils.match_password(pswd, t_auth_user.password) then
        update auth.auth_user
        set login_try_count = login_try_count + 1
        where id = t_auth_user.id
        returning login_try_count into v_login_try_count;
                
        if v_login_try_count = 3 then
            insert into auth.auth_blocked_user (user_id, blocked_for, blocked_till, blocked_by)
            values (t_auth_user.id, 'ERROR_LOGIN_TRY_COUNT', now() + interval '1 min', -1);
        end if;
        commit;

        raise exception '%',utils.error_message('BAD_CREDENTIALS');
    end if;
    t_organization = organization.isorganizationactive(t_auth_user.organization_id);


    response = jsonb_build_object('id', t_auth_user.id);
    response = response || jsonb_build_object('code', t_auth_user.code);
    response = response || jsonb_build_object('username', t_auth_user.username);
    response = response || jsonb_build_object('email', t_auth_user.email);
    response = response || jsonb_build_object('phone', t_auth_user.phone);
    response = response || jsonb_build_object('first_name', t_auth_user.first_name);
    response = response || jsonb_build_object('last_name', t_auth_user.last_name);
    response = response || jsonb_build_object('created_at', t_auth_user.created_at);
    response = response || jsonb_build_object('is_super_user', t_auth_user.is_super_user);
    response = response || jsonb_build_object('language', t_auth_user.language);
    response = response || jsonb_build_object('roles', auth.user_roles(t_auth_user.id));
    response = response || jsonb_build_object('permissions', auth.user_permissions(t_auth_user.id));
    response = response || jsonb_build_object('organization', organization.organization_detail(t_organization)::jsonb);

    _out := response::text;

    -- exception
--     when others then
--         get stacked diagnostics
--             v_state = returned_sqlstate,
--             v_msg = message_text,
--             v_detail = pg_exception_detail,
--             v_hint = pg_exception_hint,
--             v_context = pg_exception_context;

    /* raise exception E'Got exception:
             state  : %
             message: %
             detail: %
             hint: %
             context: %
             SQLSTATE: %
             SQLERRM: %', v_state, v_msg, v_detail, v_hint, v_context,SQLSTATE, SQLERRM;*/
end
$$;


ALTER PROCEDURE auth.login(uname character varying, pswd character varying, INOUT _out text) OWNER TO postgres;

--
-- Name: user_permissions(bigint); Type: FUNCTION; Schema: auth; Owner: postgres
--

CREATE FUNCTION auth.user_permissions(userid bigint) RETURNS jsonb
    LANGUAGE plpgsql
    AS $$
declare
    t_user record;
begin
    return (select array_to_json(array_agg((select row_to_json("table"))))
            from (select ap.*
                  from auth.auth_user aur
                           inner join auth.auth_user_permission arp on aur.id = arp.user_id
                           inner join auth.auth_permission ap on ap.id = arp.permission_id
                  where aur.id = userid
                 ) "table");
end
$$;


ALTER FUNCTION auth.user_permissions(userid bigint) OWNER TO postgres;

--
-- Name: user_role(bigint); Type: FUNCTION; Schema: auth; Owner: postgres
--

CREATE FUNCTION auth.user_role(role_id bigint) RETURNS jsonb
    LANGUAGE plpgsql
    AS $$
declare
    r_auth_role record;
    response    jsonb;
begin

    select * into r_auth_role from auth.auth_role where id = role_id;
    if FOUND then
        response = jsonb_build_object('id', r_auth_role.id);
        response = response || jsonb_build_object('code', r_auth_role.code);
        response = response || jsonb_build_object('name', r_auth_role.name);
    end if;
    return response;
end
$$;


ALTER FUNCTION auth.user_role(role_id bigint) OWNER TO postgres;

--
-- Name: user_roles(bigint); Type: FUNCTION; Schema: auth; Owner: postgres
--

CREATE FUNCTION auth.user_roles(userid bigint) RETURNS jsonb
    LANGUAGE plpgsql
    AS $$
begin
    return json_agg((select row_to_json(myTable)
                     from (select ar.*
                           from auth.auth_role ar
                                    inner join auth.auth_user_role aur on ar.id = aur.role_id
                           where aur.user_id = userid
                          ) myTable))::jsonb;
end
$$;


ALTER FUNCTION auth.user_roles(userid bigint) OWNER TO postgres;

--
-- Name: check_auth_user_create_dto(auth.auth_user_create_dto); Type: FUNCTION; Schema: checks; Owner: postgres
--

CREATE FUNCTION checks.check_auth_user_create_dto(dto auth.auth_user_create_dto) RETURNS auth.auth_user_create_dto
    LANGUAGE plpgsql
    AS $_$
begin
    if dto.phone is null or dto.phone !~ '^([0-9]{12})$' then
        raise exception 'BAD_REQUEST';
    end if;

    if exists(select * from auth.auth_user where phone = dto.phone) then
        raise exception 'PHONE_IS_ALREADY_TAKEN';
    end if;

    if dto.username is null then
        raise exception 'BAD_REQUEST';
    end if;

    if exists(select * from auth.auth_user where username = dto.username) then
        raise exception 'USERNAME_IS_ALREADY_TAKEN';
    end if;

    if dto.email is null or dto.email !~ '[^@ \t\r\n]+@[^@ \t\r\n]+\.[^@ \t\r\n]+' then
        raise exception 'BAD_REQUEST';
    end if;

    if exists(select * from auth.auth_user where email = dto.email) then
        raise exception 'EMAIL_IS_ALREADY_TAKEN';
    end if;

    if dto.password is null then
        raise exception 'BAD_REQUEST';
    end if;

    if not utils.isstrongpassword(dto.password) then
        raise exception 'WEAK_PASSWORD';
    end if;

    if dto.language is null or dto.language not in (select code from settings.language) then
        dto.language = 'RU';
    end if;

    if dto.organization_id is null then
        raise exception 'BAD_REQUEST';
    end if;

    return dto;
end;
$_$;


ALTER FUNCTION checks.check_auth_user_create_dto(dto auth.auth_user_create_dto) OWNER TO postgres;

--
-- Name: check_column_create_dto(project.column_create_dto); Type: FUNCTION; Schema: checks; Owner: postgres
--

CREATE FUNCTION checks.check_column_create_dto(dto project.column_create_dto) RETURNS project.column_create_dto
    LANGUAGE plpgsql
    AS $$
BEGIN
    if (dto.name) is null or dto.project_id is null then
        raise exception 'BAD_REQUEST';
    end if;

    dto.order = (select count(*) from project.project_column where project_id = dto.project_id and not is_deleted) + 1;

    return dto;
END
$$;


ALTER FUNCTION checks.check_column_create_dto(dto project.column_create_dto) OWNER TO postgres;

--
-- Name: check_organization_create_dto(organization.organization_create_dto); Type: PROCEDURE; Schema: checks; Owner: postgres
--

CREATE PROCEDURE checks.check_organization_create_dto(dto organization.organization_create_dto)
    LANGUAGE plpgsql
    AS $$
begin
    if (dto.name is null) then
        raise exception 'BAD_REQUEST';
    end if;

    if exists(select o.name from organization.organization o where not o.is_deleted and o.name ilike dto.name) then
        raise exception 'ORGANIZATION_NAME_ALREADY_TAKEN';
    end if;

    if (dto.reg_number is null) then
        raise exception 'BAD_REQUEST';
    end if;
end
$$;


ALTER PROCEDURE checks.check_organization_create_dto(dto organization.organization_create_dto) OWNER TO postgres;

--
-- Name: check_organization_update_dto(organization.organization_update_dto); Type: FUNCTION; Schema: checks; Owner: postgres
--

CREATE FUNCTION checks.check_organization_update_dto(dto organization.organization_update_dto) RETURNS organization.organization_update_dto
    LANGUAGE plpgsql
    AS $$
declare
    t_organization record;
begin
    if (dto.id is null) then
        raise exception 'BAD_REQUEST';
    end if;

    select * into t_organization from organization.organization where not is_deleted and id = dto.id;
    if not FOUND then
        raise exception 'ORGANIZATION_NOT_FOUND';
    end if;

    if (dto.email is null) then
        dto.email = t_organization.email;
    end if;

    if (dto.logo is null) then
        dto.logo = t_organization.logo;
    end if;

    if (dto.website is null) then
        dto.website = t_organization.website;
    end if;

    if (dto.location is null) then
        dto.location = t_organization.location;
    end if;

    return dto;
end
$$;


ALTER FUNCTION checks.check_organization_update_dto(dto organization.organization_update_dto) OWNER TO postgres;

--
-- Name: check_permission_set_dto(permission.permission_set_dto); Type: FUNCTION; Schema: checks; Owner: postgres
--

CREATE FUNCTION checks.check_permission_set_dto(dto permission.permission_set_dto) RETURNS permission.permission_set_dto
    LANGUAGE plpgsql
    AS $$
declare
begin
    if dto.id is null then
        raise exception 'ID_NOT_PROVIDED';
    end if;
    
    if dto.permission is null then
        raise exception 'ID_NOT_PROVIDED';
    end if;
    
    return dto;
end
$$;


ALTER FUNCTION checks.check_permission_set_dto(dto permission.permission_set_dto) OWNER TO postgres;

--
-- Name: check_project_create_dto(project.project_create_dto); Type: FUNCTION; Schema: checks; Owner: postgres
--

CREATE FUNCTION checks.check_project_create_dto(dto project.project_create_dto) RETURNS project.project_create_dto
    LANGUAGE plpgsql
    AS $$
DECLARE
BEGIN
    if (dto.name is null) then
        raise exception 'BAD_REQUEST';
    end if;
    return dto;
END
$$;


ALTER FUNCTION checks.check_project_create_dto(dto project.project_create_dto) OWNER TO postgres;

--
-- Name: check_project_update_dto(project.project_update_dto); Type: FUNCTION; Schema: checks; Owner: postgres
--

CREATE FUNCTION checks.check_project_update_dto(dto project.project_update_dto) RETURNS project.project_update_dto
    LANGUAGE plpgsql
    AS $$
declare
    t_project project.project%rowtype;
begin
    if dto.id is null then
        raise exception 'ID_NOT_PROVIDED';
    end if;

    if dto.organization_id is null then
        raise exception 'BAD_REQUEST';
    end if;

    select * into t_project from project.project p where p.id = dto.id;
    if not found or not t_project.organization_id = dto.organization_id then
        raise exception 'PROJECT_NOT_FOUND';
    end if;

    if dto.name is null then
        dto.name := t_project.name;
    end if;

    if dto.background is null then
        dto.background := t_project.background;
    end if;

    if dto.tz is null then
        dto.tz := t_project.tz;
    end if;

    if dto.description is null then
        dto.description := t_project.description;
    end if;
    
    return dto;
end
$$;


ALTER FUNCTION checks.check_project_update_dto(dto project.project_update_dto) OWNER TO postgres;

--
-- Name: check_task_create_dto(task.task_create_dto); Type: FUNCTION; Schema: checks; Owner: postgres
--

CREATE FUNCTION checks.check_task_create_dto(dto task.task_create_dto) RETURNS task.task_create_dto
    LANGUAGE plpgsql
    AS $$
begin
    if dto.name is null then
        raise exception 'NAME_NOT_PROVIDED';
    end if;

    if dto.project_column_id is null then
        raise exception 'PROJECT_COLUMN_ID_NOT_PROVIDED';
    end if;
    return dto;
end
$$;


ALTER FUNCTION checks.check_task_create_dto(dto task.task_create_dto) OWNER TO postgres;

--
-- Name: check_task_update_dto(task.task_update_dto); Type: FUNCTION; Schema: checks; Owner: postgres
--

CREATE FUNCTION checks.check_task_update_dto(dto task.task_update_dto) RETURNS task.task_update_dto
    LANGUAGE plpgsql
    AS $$
declare
    t_task task.task%rowtype;
begin
    if dto.id is null then
        raise exception 'ID_NOT_PROVIDED';
    end if;
    
    if dto.project_column_id is null then
        raise exception 'PROJECT_COLUMN_ID_NOT_PROVIDED';
    end if;

--    if exists(select * from project.project_column where id= dto.project_column_id) then
--     raise exception 'INVALID_COLUMN_ID';
-- end if;
    
    select * into t_task from task.task where task.id = dto.id;
    
    if dto.name is null then
        dto.name = t_task.name;
    end if;
    
    if dto.deadline is null then
        dto.deadline = t_task.deadline;
    end if;

    if dto.description is null then
        dto.description = t_task.description;
    end if;

    if dto.priority is null then
        dto.priority = t_task.priority;
    end if;

    if dto.level is null then
        dto.level = t_task.level;
    end if;

    if dto."order" is null then
        dto."order" = t_task."order";
    end if;
    return dto;
end
$$;


ALTER FUNCTION checks.check_task_update_dto(dto task.task_update_dto) OWNER TO postgres;

--
-- Name: is_admin_of_organization(bigint, bigint); Type: FUNCTION; Schema: checks; Owner: postgres
--

CREATE FUNCTION checks.is_admin_of_organization(userid bigint, organizationid bigint) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
DECLARE
    t_auth_user auth.auth_user%rowtype;
BEGIN
    t_auth_user = auth.is_active(userid);
    return (t_auth_user.organization_id = organizationid and auth.hasanyrole('ADMIN', userid));
END
$$;


ALTER FUNCTION checks.is_admin_of_organization(userid bigint, organizationid bigint) OWNER TO postgres;

--
-- Name: is_project_member(bigint, bigint); Type: FUNCTION; Schema: checks; Owner: postgres
--

CREATE FUNCTION checks.is_project_member(userid bigint, projectid bigint) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
BEGIN
    return exists(select *
                  from project.project_member
                  where project_id = projectid and user_id = userid and not is_deleted);
END
$$;


ALTER FUNCTION checks.is_project_member(userid bigint, projectid bigint) OWNER TO postgres;

--
-- Name: to_auth_user_create_dto(json); Type: FUNCTION; Schema: mappers; Owner: postgres
--

CREATE FUNCTION mappers.to_auth_user_create_dto(data json) RETURNS auth.auth_user_create_dto
    LANGUAGE plpgsql
    AS $$
declare
    response auth.auth_user_create_dto;
begin
    response.username := data ->> 'username';
    response.password := data ->> 'password';
    response.email := data ->> 'email';
    response.phone := data ->> 'phone';
    response.language := data ->> 'language';
    response.first_name := data ->> 'firstName';
    response.last_name := data ->> 'lastName';
    response.organization_id := (data ->> 'organizationId')::bigint;
    return response;
end
$$;


ALTER FUNCTION mappers.to_auth_user_create_dto(data json) OWNER TO postgres;

--
-- Name: to_column_create_dto(json); Type: FUNCTION; Schema: mappers; Owner: postgres
--

CREATE FUNCTION mappers.to_column_create_dto(data json) RETURNS project.column_create_dto
    LANGUAGE plpgsql
    AS $$
DECLARE
    dto project.column_create_dto;
BEGIN
    dto.project_id = (data ->> 'project_id')::bigint;
    dto.name = data ->> 'name';
    dto.emoji = data ->> 'emoji';

    return dto;
END
$$;


ALTER FUNCTION mappers.to_column_create_dto(data json) OWNER TO postgres;

--
-- Name: to_organization_create_dto(json); Type: FUNCTION; Schema: mappers; Owner: postgres
--

CREATE FUNCTION mappers.to_organization_create_dto(data json) RETURNS organization.organization_create_dto
    LANGUAGE plpgsql
    AS $$
declare
    response organization.organization_create_dto;
begin
    response.name := data ->> 'name';
    response.website := data ->> 'website';
    response.email := data ->> 'email';
    response.logo := data ->> 'logo';
    response.reg_number := data ->> 'regNumber';
--     response.location := data ->> 'location';

    return response;
end
$$;


ALTER FUNCTION mappers.to_organization_create_dto(data json) OWNER TO postgres;

--
-- Name: to_organization_update_dto(json); Type: FUNCTION; Schema: mappers; Owner: postgres
--

CREATE FUNCTION mappers.to_organization_update_dto(data json) RETURNS organization.organization_update_dto
    LANGUAGE plpgsql
    AS $$
declare
    v_dto organization.organization_update_dto;
begin
    v_dto.id = (data ->> 'id')::bigint;
    v_dto.email = data ->> 'email';
    v_dto.website = data ->> 'website';
    v_dto.logo = data ->> 'logo';
    v_dto.location = (data ->> 'location')::point;
    return v_dto;
end
$$;


ALTER FUNCTION mappers.to_organization_update_dto(data json) OWNER TO postgres;

--
-- Name: to_permission_set_dto(json); Type: FUNCTION; Schema: mappers; Owner: postgres
--

CREATE FUNCTION mappers.to_permission_set_dto(data json) RETURNS permission.permission_set_dto
    LANGUAGE plpgsql
    AS $$
declare
    response permission.permission_set_dto;
begin
    response.id = (data ->> 'id')::bigint;
    response.permission = (data ->> 'permission')::bigint;
    return response;
end
$$;


ALTER FUNCTION mappers.to_permission_set_dto(data json) OWNER TO postgres;

--
-- Name: to_project_create_dto(json); Type: FUNCTION; Schema: mappers; Owner: postgres
--

CREATE FUNCTION mappers.to_project_create_dto(data json) RETURNS project.project_create_dto
    LANGUAGE plpgsql
    AS $$
DECLARE
    v_dto project.project_create_dto;
BEGIN
    v_dto.name = data ->> 'name';
    v_dto.description = data ->> 'description';
    v_dto.tz = data ->> 'tz';
    v_dto.background = data ->> 'background';

    return v_dto;
END
$$;


ALTER FUNCTION mappers.to_project_create_dto(data json) OWNER TO postgres;

--
-- Name: to_project_update_dto(json); Type: FUNCTION; Schema: mappers; Owner: postgres
--

CREATE FUNCTION mappers.to_project_update_dto(data json) RETURNS project.project_update_dto
    LANGUAGE plpgsql
    AS $$
declare
    dto project.project_update_dto;
begin
    dto.id := data ->> 'id';
    dto.name := data ->> 'name';
    dto.description := data ->> 'description';
    dto.tz := data ->> 'tz';
    dto.background := data ->> 'background';
    dto.organization_id := data ->> 'organization_id';

    return dto;
end
$$;


ALTER FUNCTION mappers.to_project_update_dto(data json) OWNER TO postgres;

--
-- Name: to_task_add_comment_dto(json); Type: FUNCTION; Schema: mappers; Owner: postgres
--

CREATE FUNCTION mappers.to_task_add_comment_dto(data json) RETURNS task.task_add_comment_dto
    LANGUAGE plpgsql
    AS $$
DECLARE
    dto task.task_add_comment_dto;
BEGIN
    dto.task_id = (data ->> 'task_id')::bigint;
    if dto.task_id is null then
        raise exception 'BAD_REQUEST';
    end if;

    if not exists(select * from task.task where dto.task_id = id) then
        raise exception 'TASK_NOT_FOUND';
    end if;

    dto.message = data ->> 'message';
    if dto.message is null then
        raise exception 'BAD_REQUEST';
    end if;

    return dto;
END
$$;


ALTER FUNCTION mappers.to_task_add_comment_dto(data json) OWNER TO postgres;

--
-- Name: to_task_create_dto(json); Type: FUNCTION; Schema: mappers; Owner: postgres
--

CREATE FUNCTION mappers.to_task_create_dto(data json) RETURNS task.task_create_dto
    LANGUAGE plpgsql
    AS $$
declare
    response task.task_create_dto;
begin
    response.name := data ->> 'name';
    response.description := data ->> 'description';
    response.project_column_id := (data ->> 'project_column_id')::bigint;
    response.deadline := (data ->> 'deadline')::timestamptz;
    response.level := data ->> 'level';
    response.priority := (data ->> 'priority')::bigint;

    return response;
end
$$;


ALTER FUNCTION mappers.to_task_create_dto(data json) OWNER TO postgres;

--
-- Name: to_task_update_dto(json); Type: FUNCTION; Schema: mappers; Owner: postgres
--

CREATE FUNCTION mappers.to_task_update_dto(data json) RETURNS task.task_update_dto
    LANGUAGE plpgsql
    AS $$
declare
    response task.task_update_dto;
begin
    response.id := data ->> 'id';
    response.project_column_id := data ->> 'project_column_id';
    response.name := data ->> 'name';
    response.description := data ->> 'description';
    response.priority := data ->> 'priority';
    response.level := data ->> 'level';
    response.order := data ->> 'order';
    response.deadline := data ->> 'deadline';
    return response;
end
$$;


ALTER FUNCTION mappers.to_task_update_dto(data json) OWNER TO postgres;

--
-- Name: to_user_block_dto(json); Type: FUNCTION; Schema: mappers; Owner: postgres
--

CREATE FUNCTION mappers.to_user_block_dto(data json) RETURNS auth.auth_user_block_dto
    LANGUAGE plpgsql
    AS $$
declare
    dto auth.auth_user_block_dto;
BEGIN
    dto.userid = data ->> 'id';
    dto.block_for = data ->> 'blockedFor';
    dto.block_till = data ->> 'blockedTill';
    return dto;
END
$$;


ALTER FUNCTION mappers.to_user_block_dto(data json) OWNER TO postgres;

--
-- Name: delete_all_organization_belongs(bigint, bigint); Type: PROCEDURE; Schema: organization; Owner: postgres
--

CREATE PROCEDURE organization.delete_all_organization_belongs(organizationid bigint, userid bigint)
    LANGUAGE plpgsql
    AS $$
declare
    v_project_id_array bigint[];
begin
    update auth.auth_user set is_deleted = true where organization_id = organizationid;

    update project.project
    set is_deleted = true,
        updated_at = now(),
        updated_by = userid
    where organization_id = organizationid
    returning id into v_project_id_array;

    update project.project_label pl
    set is_deleted = true,
        updated_at = now(),
        updated_by = userid
    where pl.project_id = any (v_project_id_array);

    update project.project_column pc
    set is_deleted = true,
        updated_at = now(),
        updated_by = userid
    where project_id = any (v_project_id_array);

end
$$;


ALTER PROCEDURE organization.delete_all_organization_belongs(organizationid bigint, userid bigint) OWNER TO postgres;

--
-- Name: isorganizationactive(bigint); Type: FUNCTION; Schema: organization; Owner: postgres
--

CREATE FUNCTION organization.isorganizationactive(organizationid bigint) RETURNS record
    LANGUAGE plpgsql
    AS $$
declare
    org record;
begin
    select * into org from organization.organization where not is_deleted and id = organizationid;
    if not FOUND then
        --TODO localize this
        raise exception 'ORGANIZATION_NOT_FOUND';
    end if;

    if org.status <> 0 then
        --TODO localize this
        raise exception 'ORGANIZATION_IS_NOT_ACTIVE';
    end if;
    return org;
end
$$;


ALTER FUNCTION organization.isorganizationactive(organizationid bigint) OWNER TO postgres;

--
-- Name: organization_block(bigint, bigint); Type: PROCEDURE; Schema: organization; Owner: postgres
--

CREATE PROCEDURE organization.organization_block(organizationid bigint, userid bigint)
    LANGUAGE plpgsql
    AS $$
BEGIN
    call organization.organization_change_status(-1, organizationid, userid);
END
$$;


ALTER PROCEDURE organization.organization_block(organizationid bigint, userid bigint) OWNER TO postgres;

--
-- Name: organization_change_status(smallint, bigint, bigint); Type: PROCEDURE; Schema: organization; Owner: postgres
--

CREATE PROCEDURE organization.organization_change_status(new_status smallint, organizationid bigint, userid bigint)
    LANGUAGE plpgsql
    AS $$
declare
    t_auth_user auth.auth_user%rowtype;
begin
    t_auth_user = auth.is_active(userid);
    if not t_auth_user.is_super_user then
        raise exception 'PERMISSION_DENIED';
    end if;

    update organization.organization
    set status = new_status
    where id = organizationid;


end
$$;


ALTER PROCEDURE organization.organization_change_status(new_status smallint, organizationid bigint, userid bigint) OWNER TO postgres;

--
-- Name: organization_create(text, bigint); Type: FUNCTION; Schema: organization; Owner: postgres
--

CREATE FUNCTION organization.organization_create(dataparam text, userid bigint) RETURNS bigint
    LANGUAGE plpgsql
    AS $$
declare
    t_auth_user auth.auth_user%rowtype;
    dto         organization.organization_create_dto;
    v_id        bigint;
begin
    t_auth_user = auth.is_active(userid);

    call utils.check_data(dataparam);

    dto = mappers.to_organization_create_dto(dataparam::json);

    call checks.check_organization_create_dto(dto);

    if not t_auth_user.is_super_user then
        raise exception 'PERMISSION_DENIED';
    end if;

    insert into organization.organization (name, website, email, logo, reg_num, paid_for, created_by)
    values (dto.name, dto.website, dto.email, dto.logo, dto.reg_number, (now() + interval '1 year'), userid)
    returning id into v_id;

    return v_id;
end
$$;


ALTER FUNCTION organization.organization_create(dataparam text, userid bigint) OWNER TO postgres;

--
-- Name: organization_delete(bigint, bigint); Type: PROCEDURE; Schema: organization; Owner: postgres
--

CREATE PROCEDURE organization.organization_delete(organizationid bigint, userid bigint)
    LANGUAGE plpgsql
    AS $$
DECLARE
    t_auth_user auth.auth_user%rowtype;
BEGIN
    t_auth_user = auth.is_active(userid);

    if not t_auth_user.is_super_user then
        raise exception 'PERMISSION_DENIED';
    end if;

    update organization.organization o
    set is_deleted = true
    where o.id = organizationid;
    call organization.delete_all_organization_belongs(organizationid, userid);

END;
$$;


ALTER PROCEDURE organization.organization_delete(organizationid bigint, userid bigint) OWNER TO postgres;

--
-- Name: organization_detail(bigint); Type: FUNCTION; Schema: organization; Owner: postgres
--

CREATE FUNCTION organization.organization_detail(organizationid bigint) RETURNS text
    LANGUAGE plpgsql
    AS $$
declare
    org              record;
    organizationJson jsonb;
begin
    select * into org from organization.organization where not is_deleted and id = organizationid;
    if not FOUND then
        --TODO localize this
        raise exception 'ORGANIZATION_NOT_FOUND';
    end if;

    if org.status <> 0 then
        --TODO localize this
        raise exception 'ORGANIZATION_IS_NOT_ACTIVE';
    end if;

    organizationJson = jsonb_build_object('id', org.id);
    organizationJson = organizationJson || jsonb_build_object('name', org.name);
    organizationJson = organizationJson || jsonb_build_object('email', org.email);
    organizationJson = organizationJson || jsonb_build_object('website', org.website);
    organizationJson = organizationJson || jsonb_build_object('logo', org.logo);
    organizationJson = organizationJson || jsonb_build_object('location', org.location);
    organizationJson = organizationJson || jsonb_build_object('created_at', org.created_at);
    organizationJson = organizationJson || jsonb_build_object('reg_num', org.reg_num);
    organizationJson = organizationJson || jsonb_build_object('paid_for', org.paid_for);
    return organizationJson::text;
end
$$;


ALTER FUNCTION organization.organization_detail(organizationid bigint) OWNER TO postgres;

--
-- Name: organization_detail(record); Type: FUNCTION; Schema: organization; Owner: postgres
--

CREATE FUNCTION organization.organization_detail(organization record) RETURNS text
    LANGUAGE plpgsql
    AS $$
declare
    organizationJson jsonb;
begin
    organizationJson = jsonb_build_object('id', organization.id);
    organizationJson = organizationJson || jsonb_build_object('name', organization.name);
    organizationJson = organizationJson || jsonb_build_object('email', organization.email);
    organizationJson = organizationJson || jsonb_build_object('website', organization.website);
    organizationJson = organizationJson || jsonb_build_object('logo', organization.logo);
    organizationJson = organizationJson || jsonb_build_object('location', organization.location);
    organizationJson = organizationJson || jsonb_build_object('created_at', organization.created_at);
    organizationJson = organizationJson || jsonb_build_object('reg_num', organization.reg_num);
    organizationJson = organizationJson || jsonb_build_object('paid_for', organization.paid_for);
    return organizationJson::text;
end
$$;


ALTER FUNCTION organization.organization_detail(organization record) OWNER TO postgres;

--
-- Name: organization_list(bigint); Type: FUNCTION; Schema: organization; Owner: postgres
--

CREATE FUNCTION organization.organization_list(userid bigint) RETURNS text
    LANGUAGE plpgsql
    AS $$
declare
    t_auth_user auth.auth_user%rowtype;
begin
    t_auth_user = auth.is_active(userid);

    if not t_auth_user.is_super_user then
        raise exception 'PERMISSION_DENIED';
    end if;

    return (select array_to_json(array_agg(row_to_json(organizationColumn)))
            from (select * from organization.organization o where not o.is_deleted) organizationColumn)::text;
end
$$;


ALTER FUNCTION organization.organization_list(userid bigint) OWNER TO postgres;

--
-- Name: organization_unblock(bigint, bigint); Type: PROCEDURE; Schema: organization; Owner: postgres
--

CREATE PROCEDURE organization.organization_unblock(organizationid bigint, userid bigint)
    LANGUAGE plpgsql
    AS $$
BEGIN
    call organization.organization_change_status(0, organizationid, userid);
END
$$;


ALTER PROCEDURE organization.organization_unblock(organizationid bigint, userid bigint) OWNER TO postgres;

--
-- Name: organization_update(text, bigint); Type: FUNCTION; Schema: organization; Owner: postgres
--

CREATE FUNCTION organization.organization_update(dataparam text, userid bigint) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
DECLARE
    dto         organization.organization_update_dto;
    t_auth_user auth.auth_user%rowtype;
BEGIN

    t_auth_user = auth.is_active(userid);

    call utils.check_data(dataparam);

    dto = mappers.to_organization_update_dto(dataparam::json);

    dto = checks.check_organization_update_dto(dto);

    if not ((auth.hasanypermission('UPDATE_ORGANIZATION', userid) and t_auth_user.organization_id = dto.id)
        or t_auth_user.is_super_user) then
        raise exception 'PERMISSION_DENIED';
    end if;

    update organization.organization o
    set email    = dto.email,
        website  = dto.website,
        logo     = dto.logo,
        location = dto.location
    where o.id = dto.id;

    return true;
END;
$$;


ALTER FUNCTION organization.organization_update(dataparam text, userid bigint) OWNER TO postgres;

--
-- Name: permission_set(bigint, text); Type: FUNCTION; Schema: permission; Owner: postgres
--

CREATE FUNCTION permission.permission_set(session bigint, dataparam text) RETURNS bigint
    LANGUAGE plpgsql
    AS $$
declare
    t_auth_user auth.auth_user%rowtype;
    v_dto       permission.permission_set_dto;
begin
    t_auth_user = auth.is_active(session);

    if not auth.hasanypermission('PERMISSION_SET', session) then
        raise exception 'PERMISSION_DENIED';
    end if;
    call utils.check_data(dataparam);
    v_dto = mappers.to_permission_set_dto(dataparam::json);
    v_dto = checks.check_permission_set_dto(v_dto);

    if exists(select user_id from auth.auth_user_permission where permission_id = v_dto.permission) then
        raise exception 'PERMISSION_ALREADY_TAKEN';
    end if;
    insert into auth.auth_user_permission (user_id, permission_id) values (v_dto.id, v_dto.permission);
    return t_auth_user.id;
end
$$;


ALTER FUNCTION permission.permission_set(session bigint, dataparam text) OWNER TO postgres;

--
-- Name: isactiveproject(bigint); Type: FUNCTION; Schema: project; Owner: postgres
--

CREATE FUNCTION project.isactiveproject(projectid bigint) RETURNS record
    LANGUAGE plpgsql
    AS $$
DECLARE
    res record;
BEGIN
    select * into res from project.project p where not p.is_deleted and p.id = projectid and p.status = 0;

    if not FOUND then
        raise exception 'PROJECT_NOT_FOUND';
    end if;

    if res.is_archived then
        raise exception 'PROJECT_IS_ARCHIVED';
    end if;

    return res;

END
$$;


ALTER FUNCTION project.isactiveproject(projectid bigint) OWNER TO postgres;

--
-- Name: isprojectmember(bigint, bigint); Type: FUNCTION; Schema: project; Owner: postgres
--

CREATE FUNCTION project.isprojectmember(projectid bigint, userid bigint) RETURNS record
    LANGUAGE plpgsql
    AS $$
DECLARE
    t_project_member record;
BEGIN

    select * into t_project_member
                  from project.project_member pm
                  where not pm.is_deleted
                    and pm.project_id = projectid
                    and pm.user_id = userid;
    if not found then
        raise exception 'PROJECT_MEMBERS_NOT_FOUND';
    end if;
    
    return t_project_member;
END
$$;


ALTER FUNCTION project.isprojectmember(projectid bigint, userid bigint) OWNER TO postgres;

--
-- Name: project_add_member(bigint, bigint, bigint); Type: FUNCTION; Schema: project; Owner: postgres
--

CREATE FUNCTION project.project_add_member(projectid bigint, memberid bigint, userid bigint) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
declare
    t_auth_user      auth.auth_user%rowtype;
    t_project        project.project%rowtype;
    t_project_member project.project_member%rowtype;
begin
    t_auth_user = auth.is_active(memberid);
    
    t_auth_user = auth.is_active(userid);

    t_project = project.isactiveproject(projectid);

--     t_project_member = project.isprojectmember(projectid, userid);

    if not ((t_auth_user.organization_id = t_project.organization_id)
        or auth.hasanyrole('ADMIN#HR#MANAGER', userid)
        or t_project_member.is_lead) then
        raise exception 'PERMISSION_DENIED';
    end if;

    select *
    into t_project_member
    from project.project_member pm
    where pm.user_id = memberid
      and pm.project_id = project_id;
    if FOUND then
        raise exception 'MEMBER_IS_ALREADY_ADDED';
    end if;

    insert into project.project_member (project_id, user_id, created_by) values (projectid, memberid, userid);
    return true;
end
$$;


ALTER FUNCTION project.project_add_member(projectid bigint, memberid bigint, userid bigint) OWNER TO postgres;

--
-- Name: project_block(bigint, bigint); Type: FUNCTION; Schema: project; Owner: postgres
--

CREATE FUNCTION project.project_block(userid bigint, projectid bigint) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
DECLARE
    t_project        project.project%rowtype;
    t_project_member project.project_member%rowtype;
    auth_u           auth.auth_user%rowtype;
begin
    perform auth.is_active(userid);

    t_project = project.isactiveproject(projectId);

    t_project_member = project.isprojectmember(projectId, userid);

    if not (auth_u.organization_id = t_project.organization_id
        or auth.hasanypermission('PROJECT_BLOCK', userid)
        or t_project_member.is_lead or auth.hasanyrole('ADMIN', userid)) then
        raise exception 'PERMISSION_DENIED';
    end if;

    update project.project set status = -1 where project.id = projectId;
    return true;
end
$$;


ALTER FUNCTION project.project_block(userid bigint, projectid bigint) OWNER TO postgres;

--
-- Name: project_column_change_order(bigint, smallint); Type: PROCEDURE; Schema: project; Owner: postgres
--

CREATE PROCEDURE project.project_column_change_order(columnid bigint, new_order smallint)
    LANGUAGE plpgsql
    AS $$
DECLARE
    count    smallint;
    t_pr_col project.project_column%rowtype;
BEGIN
    select pc.* into t_pr_col from project.project_column pc where pc.id = columnid;
    count = (select count(*) from project.project_column where project_id = t_pr_col.project_id and not is_deleted);

    if new_order > count and not new_order = 32000 then
        new_order = count;
    else
        if new_order < 1 then
            new_order = 1;
        end if;
    end if;

    if new_order > t_pr_col."order" then
        update project.project_column
        set "order" = "order" - 1
        where "order" <= new_order
          and "order" > t_pr_col."order"
          and id <> columnid
          and project_id = t_pr_col.project_id;

        update project.project_column
        set "order" = new_order
        where id = columnid;
    end if;

    if new_order < t_pr_col."order" then
        update project.project_column
        set "order" = "order" + 1
        where "order" >= new_order
          and "order" < t_pr_col."order"
          and id <> columnid
          and project_id = t_pr_col.project_id;

        update project.project_column
        set "order" = new_order
        where id = columnid;
    end if;

END
$$;


ALTER PROCEDURE project.project_column_change_order(columnid bigint, new_order smallint) OWNER TO postgres;

--
-- Name: project_column_create(text, bigint); Type: FUNCTION; Schema: project; Owner: postgres
--

CREATE FUNCTION project.project_column_create(dataparam text, userid bigint) RETURNS bigint
    LANGUAGE plpgsql
    AS $$
DECLARE
    dto         project.column_create_dto;
    t_auth_user auth.auth_user%rowtype;
    pr_org_id   bigint;
    new_id      bigint;
BEGIN
    t_auth_user = auth.is_active(userid);
    call utils.check_data(dataparam);
    dto = mappers.to_column_create_dto(dataparam::json);
    dto = checks.check_column_create_dto(dto);

    select pr.organization_id
    into pr_org_id
    from project.project pr
    where id = dto.project_id
      and not is_deleted;

    if not (checks.is_project_member(userid, dto.project_id)
        or checks.is_admin_of_organization(userid, pr_org_id)) then
        raise exception 'PERMISSION_DENIED';
    end if;

    insert into project.project_column (name, emoji, project_id, "order", created_at, created_by)
    values (dto.name, dto.emoji, dto.project_id, dto.order, current_timestamp, userid)
    returning id into new_id;

    return new_id;
END
$$;


ALTER FUNCTION project.project_column_create(dataparam text, userid bigint) OWNER TO postgres;

--
-- Name: project_column_delete(bigint, bigint); Type: FUNCTION; Schema: project; Owner: postgres
--

CREATE FUNCTION project.project_column_delete(userid bigint, columnid bigint) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
DECLARE
    t_auth_user auth.auth_user%rowtype;
    t_pr_column record;
    t_pr_member record;
BEGIN
    t_auth_user = auth.is_active(userid);

    select pc.*, p.created_by as project_owner, p.organization_id
    into t_pr_column
    from project.project_column pc
             inner join project.project p on p.id = pc.project_id
    where pc.id = columnid
      and not p.is_deleted;

    if not FOUND then
        raise exception 'NOT_FOUND';
    end if;

    select *
    into t_pr_member
    from project.project_member
    where project_id = t_pr_column.project_id
      and not is_deleted
      and user_id = userid
      and is_lead;

    if not FOUND or not checks.is_admin_of_organization(userid, t_pr_column.organization_id) then
        raise exception 'PERMISSION_DENIED';
    end if;

    update project.project_column
    set is_deleted = true,
        updated_by = userid,
        updated_at = now()
    where id = columnid;

    update task.task
    set is_deleted = true,
        updated_at = now(),
        updated_by = userid
    where project_column_id = columnid;

    call project.change_column_order(columnid, 32000::smallint);

    return true;
END
$$;


ALTER FUNCTION project.project_column_delete(userid bigint, columnid bigint) OWNER TO postgres;

--
-- Name: project_columns_detail(bigint); Type: FUNCTION; Schema: project; Owner: postgres
--

CREATE FUNCTION project.project_columns_detail(projectid bigint) RETURNS jsonb
    LANGUAGE plpgsql
    AS $$
DECLARE
BEGIN
    perform project.isactiveproject(projectid);
    
    return array_to_json(array_agg((select row_to_json(projectColumn)
                                    from (
                                             select pc.id, pc.name, pc.emoji, task.task_details(pc.id) as tasks
                                             from project.project_column pc
                                             where not pc.is_deleted
                                               and pc.project_id = projectid
                                             order by pc."order"
                                         ) projectColumn)));
END
$$;


ALTER FUNCTION project.project_columns_detail(projectid bigint) OWNER TO postgres;

--
-- Name: project_create(text, bigint); Type: FUNCTION; Schema: project; Owner: postgres
--

CREATE FUNCTION project.project_create(dataparam text, userid bigint) RETURNS bigint
    LANGUAGE plpgsql
    AS $$
DECLARE
    v_dto          project.project_create_dto;
    t_session_user auth.auth_user%rowtype;
    newId          bigint;
BEGIN
    t_session_user = auth.is_active(userid);
    call utils.check_data(dataparam);
    if not (auth.hasanypermission('CREATE_PROJECT', userid) or t_session_user.is_super_user) then
        raise exception 'PERMISSION_DENIED';
    end if;

    v_dto = mappers.to_project_create_dto(dataparam::json);
    v_dto.organization_id = t_session_user.organization_id;
    v_dto = checks.check_project_create_dto(v_dto);

    insert into project.project (name, code, background, tz, description, organization_id, created_by)
    values (v_dto.name, buildins.gen_random_uuid()::varchar, v_dto.background, v_dto.tz, v_dto.description,
            v_dto.organization_id, userid)
    returning id into newId;
    
    insert into project.project_member (project_id, user_id, created_by, is_lead)
    values (newId, userid, userid, true);
    
    return newId;
END
$$;


ALTER FUNCTION project.project_create(dataparam text, userid bigint) OWNER TO postgres;

--
-- Name: project_delete(bigint, bigint); Type: FUNCTION; Schema: project; Owner: postgres
--

CREATE FUNCTION project.project_delete(userid bigint, projectid bigint) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
declare
    t_project_column_id bigint;
    t_task_id           bigint;
    t_auth_user         auth.auth_user%rowtype;
begin
    perform auth.is_active(userid);

    if not (checks.is_project_member(userid, projectid)
        or auth.hasanypermission('PROJECT_DELETE', userid)
        or auth.hasAnyRole('ADMIN', userid)) then
        raise exception 'PERMISSION_DENIED';
    end if;

    if
        exists(select * from project.project pr where is_deleted or not pr.id = projectid) then
        raise exception 'PROJECT_NOT_FOUND';
    end if;

    update project.project
    set is_deleted = true
    where project.id = projectid;

    update project.project_label
    set is_deleted = true
    where project_id = projectid;

    update project.project_column
    set is_deleted = true
    where project_id = projectid;

    update project.project_member
    set is_deleted = true
    where project_id = projectid;

    select id into t_project_column_id from project.project_column where project_id = projectid;

    update task.task
    set is_deleted = true
    where project_column_id = t_project_column_id;

    select id into t_task_id from task.task where project_column_id = t_project_column_id;
    update task.comment
    set is_deleted = true
    where task_id = task_id;

    update task.task_member
    set is_deleted = true
    where task_id = t_task_id;

    return true;
end;
$$;


ALTER FUNCTION project.project_delete(userid bigint, projectid bigint) OWNER TO postgres;

--
-- Name: project_details(bigint, bigint); Type: FUNCTION; Schema: project; Owner: postgres
--

CREATE FUNCTION project.project_details(projectid bigint, userid bigint) RETURNS text
    LANGUAGE plpgsql
    AS $$
DECLARE
    t_session_user auth.auth_user%rowtype;
    t_project      project.project%rowtype;
    response       jsonb;
BEGIN
    t_session_user = auth.is_active(userid);
    if not (t_session_user.is_super_user
        or auth.hasanypermission('PROJECT_DETAIL', userid)
        or checks.is_project_member(projectid, userid)) then
        raise exception 'PERMISSION_DENIED';
    end if;
    t_project = project.isactiveproject(projectid);
    response = jsonb_build_object('id', projectid);
    response = response || jsonb_build_object('code', t_project.code);
    response = response || jsonb_build_object('name', t_project.name);
    response = response || jsonb_build_object('description', t_project.description);
    response = response || jsonb_build_object('tz', t_project.tz);
    response = response || jsonb_build_object('background', t_project.background);
    response = response || jsonb_build_object('organizationId', t_project.organization_id);
    response = response || jsonb_build_object('columns', project.project_columns_detail(projectid));
    response = response || jsonb_build_object('labels', project.project_labels(projectid));
    response = response || jsonb_build_object('projectMembers', project.project_members(projectid));
    return response::text;
END
$$;


ALTER FUNCTION project.project_details(projectid bigint, userid bigint) OWNER TO postgres;

--
-- Name: project_labels(bigint); Type: FUNCTION; Schema: project; Owner: postgres
--

CREATE FUNCTION project.project_labels(projectid bigint) RETURNS jsonb
    LANGUAGE plpgsql
    AS $$
declare
begin
    perform project.isactiveproject(projectid);

    return (select array_to_json(array_agg(row_to_json("table")))
            from (select pl.id, pl.color, pl.text
                  from project.project_label pl
                  where not pl.is_deleted
                    and pl.project_id = projectid) "table");

end
$$;


ALTER FUNCTION project.project_labels(projectid bigint) OWNER TO postgres;

--
-- Name: project_leave(bigint, bigint, bigint); Type: FUNCTION; Schema: project; Owner: postgres
--

CREATE FUNCTION project.project_leave(mem_id bigint, projectid bigint, userid bigint) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
declare
    t_auth auth.auth_user%rowtype;
    t_pr_mem project.project_member%rowtype;
    t_pr project.project%rowtype;
    t_auth_mem auth.auth_user%rowtype;
begin
    t_auth = auth.is_active(userid);
    t_auth_mem =  auth.is_active(mem_id);

    select * into t_pr_mem  from project.project_member pmm where pmm.user_id = mem_id and pmm.project_id = project_id;
    select * into t_pr from project.project ppp where ppp.id= projectid and ppp.organization_id = t_auth.organization_id;
    if userid = mem_id then
        delete from project.project_member pp where pp.user_id = mem_id;
        return true;
    end if;

    return false;
end
$$;


ALTER FUNCTION project.project_leave(mem_id bigint, projectid bigint, userid bigint) OWNER TO postgres;

--
-- Name: project_list(bigint); Type: FUNCTION; Schema: project; Owner: postgres
--

CREATE FUNCTION project.project_list(userid bigint) RETURNS text
    LANGUAGE plpgsql
    AS $$
declare
    t_auth_user auth.auth_user%rowtype;
begin
    t_auth_user = auth.is_active(userid);

    if not (auth.hasanypermission('PROJECT_LIST', userid) or auth.hasanyrole('ADMIN', userid)) then
        raise exception 'PERMISSION_DENIED';
    end if;

    return (select array_to_json(array_agg(row_to_json(projectColumn)))
            from (select * from project.project p where not p.is_deleted) projectColumn)::text;
end
$$;


ALTER FUNCTION project.project_list(userid bigint) OWNER TO postgres;

--
-- Name: project_members(bigint); Type: FUNCTION; Schema: project; Owner: postgres
--

CREATE FUNCTION project.project_members(projectid bigint) RETURNS jsonb
    LANGUAGE plpgsql
    AS $$
declare
begin
    perform project.isactiveproject(projectid);
    
    return (select array_to_json(array_agg((row_to_json("table"))))
            from (select pm.id memberId, pm.is_lead, auth.auth_user_info(pm.user_id)::jsonb userInfo
                  from project.project_member pm
                  where not pm.is_deleted
                    and pm.project_id = projectid) "table");

end
$$;


ALTER FUNCTION project.project_members(projectid bigint) OWNER TO postgres;

--
-- Name: project_remove_member(bigint, bigint, bigint); Type: FUNCTION; Schema: project; Owner: postgres
--

CREATE FUNCTION project.project_remove_member(projectid bigint, memberid bigint, userid bigint) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
DECLARE
    t_mem     auth.auth_user%rowtype;
    t_user    auth.auth_user%rowtype;
    t_project project.project%rowtype;
    t_pmem    project.project_member%rowtype;
    t_user_pm project.project_member%rowtype;
begin
    t_mem = auth.is_active(memberid);
    t_user = auth.is_active(userid);
    select * into t_project from project.project pr where pr.id = projectid;
    if not FOUND then
        raise exception 'PROJECT_NOT_FOUND';
    end if;

--     if not exists(select au.organization_id
--     from auth.auth_user au
--              inner join project.project_member pm on au.id = pm.user_id
--              inner join project.project p on au.organization_id = p.organization_id
--     where au.id = userid
--       and pm.user_id = memberid
--       and p.id = projectid) then
--         raise exception 'ORGANIZATION_NOT_FOUND';
--     end if;

    select * into t_user_pm from project.project_member userpm where userpm.user_id = userid;
    if not ((t_user.organization_id = t_mem.organization_id and t_user.organization_id = t_project.organization_id) or
            auth.hasanyrole('ADMIN#HR#MANAGER', userid) or t_user_pm.is_lead or
            t_user.organization_id = t_project.organization_id) then
        raise exception 'YOU_ARE_NOT_ALLOWED';
    end if;

    select *
    into t_pmem
    from project.project_member pm
    where pm.user_id = memberid
      and pm.project_id = project_id;
    if not FOUND then
        raise exception 'MEMBER_IS_NOT_FOUND';
    end if;

    delete from project.project_member pp where pp.user_id = memberid;
    return true;
end
$$;


ALTER FUNCTION project.project_remove_member(projectid bigint, memberid bigint, userid bigint) OWNER TO postgres;

--
-- Name: project_unblock(bigint, bigint); Type: FUNCTION; Schema: project; Owner: postgres
--

CREATE FUNCTION project.project_unblock(userid bigint, projectid bigint) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
declare
    t_project        project.project%rowtype;
    t_project_member project.project_member%rowtype;
    auth_u           auth.auth_user%rowtype;
begin
    perform auth.is_active(userid);

    t_project_member = project.isprojectmember(projectId, userid);

    select * into t_project from project.project pr where pr.id = projectId;
    if not FOUND or t_project.status = 0 or t_project.is_deleted then
        raise exception 'PROJECT_NOT_FOUND';
    end if;

    if not (auth_u.organization_id = t_project.organization_id
        or auth.hasanypermission('PROJECT_UNBLOCK', userid)
        or t_project_member.is_lead or auth.hasanyrole('ADMIN', userid)) then
        raise exception 'PERMISSION_DENIED';
    end if;

    update project.project set status = 0 where id = projectid;

    return true;
end
$$;


ALTER FUNCTION project.project_unblock(userid bigint, projectid bigint) OWNER TO postgres;

--
-- Name: project_update(bigint, text); Type: FUNCTION; Schema: project; Owner: postgres
--

CREATE FUNCTION project.project_update(userid bigint, dataparam text) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
declare
    dto              project.project_update_dto;
    t_project_member project.project_member%rowtype;
begin
    perform auth.is_active(userid);

    call utils.check_data(dataparam);

    dto = mappers.to_project_update_dto(dataparam::json);

    perform project.isactiveproject(dto.id);

    dto := checks.check_project_update_dto(dto);

    select * into t_project_member from project.project_member pm where pm.user_id = userid;

    if not (auth.hasanypermission('PROJECT_UPDATE', userid)
        or auth.hasanyrole('ADMIN', userid)
        or t_project_member.is_lead) then
        raise exception 'PERMISSION_DENIED';
    end if;

    update project.project
    set name        = dto.name,
        description = dto.description,
        background  = dto.background,
        tz          = dto.tz,
        updated_at  = now(),
        updated_by  = userid
    where id = dto.id;

    return true;
end;
$$;


ALTER FUNCTION project.project_update(userid bigint, dataparam text) OWNER TO postgres;

--
-- Name: to_create_project_dto(json); Type: FUNCTION; Schema: project; Owner: postgres
--

CREATE FUNCTION project.to_create_project_dto(data json) RETURNS project.project_create_dto
    LANGUAGE plpgsql
    AS $$
DECLARE
    v_dto project.project_create_dto;
BEGIN
    v_dto.name = data ->> 'name';
    v_dto.description = data ->> 'description';
    v_dto.tz = data ->> 'tz';
    v_dto.background = data ->> 'background';

    return v_dto;
END
$$;


ALTER FUNCTION project.to_create_project_dto(data json) OWNER TO postgres;

--
-- Name: is_active(bigint); Type: PROCEDURE; Schema: public; Owner: postgres
--

CREATE PROCEDURE public.is_active(v_user_id bigint)
    LANGUAGE plpgsql
    AS $$
declare
    t_auth_user  auth.auth_user%rowtype;
    t_block_user auth.auth_blocked_user%rowtype;
BEGIN
    select * into t_auth_user from auth.auth_user where not is_deleted and id = v_user_id;
    if not FOUND then
        raise exception 'USER_NOT_FOUND';
    end if;

    if t_auth_user.status <> 0 then
        raise exception 'USER_NOT_ACTIVE';
    end if;
    select *
    into t_block_user
    from auth.auth_blocked_user ab
    where not is_deleted
      and ab.user_id = v_user_id
    order by ab.blocked_till desc
    limit 1;
    
    if FOUND then
       raise exception 'USER_BLOCKED';
    end if;
END;
$$;


ALTER PROCEDURE public.is_active(v_user_id bigint) OWNER TO postgres;

--
-- Name: delete_all_organization_belongs(bigint, bigint); Type: PROCEDURE; Schema: settings; Owner: postgres
--

CREATE PROCEDURE settings.delete_all_organization_belongs(organizationid bigint, userid bigint)
    LANGUAGE plpgsql
    AS $$
declare
    v_project_id_array bigint[];
begin
    update auth.auth_user set is_deleted = true where organization_id = organizationid;

    update project.project
    set is_deleted = true,
        updated_at = now(),
        updated_by = userid
    where organization_id = organizationid
    returning id into v_project_id_array;

    update project.project_label pl
    set is_deleted = true,
        updated_at = now(),
        updated_by = userid
    where pl.project_id = any (v_project_id_array);

    update project.project_column pc
    set is_deleted = true,
        updated_at = now(),
        updated_by = userid
    where project_id = any (v_project_id_array);

end
$$;


ALTER PROCEDURE settings.delete_all_organization_belongs(organizationid bigint, userid bigint) OWNER TO postgres;

--
-- Name: get_user_tasks(bigint); Type: FUNCTION; Schema: task; Owner: postgres
--

CREATE FUNCTION task.get_user_tasks(userid bigint) RETURNS jsonb
    LANGUAGE plpgsql
    AS $$
DECLARE
BEGIN
    perform auth.is_active(userid);
    return (select array_to_json(array_agg(row_to_json("table")))
            from (
                     select t.id,
                            t.name,
                            t.description,
                            t.deadline,
                            task.task_level_val(t.level)       as level,
                            task.task_priority_val(t.priority) as priority,
                            task.task_members_details(t.id)    as members,
                            task.task_comments(t.id) ::jsonb          as comments
                     from task.task t inner join task.task_member tm on t.id = tm.task_id and tm.user_id = user_id
                 ) "table");
END
$$;


ALTER FUNCTION task.get_user_tasks(userid bigint) OWNER TO postgres;

--
-- Name: remove_member(bigint, bigint, bigint); Type: FUNCTION; Schema: task; Owner: postgres
--

CREATE FUNCTION task.remove_member(userid bigint, taskid bigint, session_id bigint) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
declare
    t_session_user auth.auth_user%rowtype;
    v_project_id   bigint;
begin
    t_session_user = auth.is_active(session_id);
    v_project_id = auth.get_project_id(session_id);
    if not (auth.hasanyrole('ADMIN', session_id) OR
            exists(select *
                   from task.task_member tm
                            inner join task.task t
                                       on t.id = taskid and tm.user_id = userid and tm.task_id = taskid)) then
        raise exception 'PERMISSION_DENIED';
    end if;
    update trello_version_3.task.task_member set is_deleted = true where user_id = userid;
    return true;
end
$$;


ALTER FUNCTION task.remove_member(userid bigint, taskid bigint, session_id bigint) OWNER TO postgres;

--
-- Name: task_add_comment(text, bigint); Type: FUNCTION; Schema: task; Owner: postgres
--

CREATE FUNCTION task.task_add_comment(dataparam text, userid bigint) RETURNS bigint
    LANGUAGE plpgsql
    AS $$
DECLARE
    dto           task.task_add_comment_dto;
    t_auth_user   auth.auth_user%rowtype;
    t_task_column record;
    new_id        bigint;
BEGIN
    t_auth_user = auth.is_active(userid);
    dto = mappers.to_task_add_comment_dto(dataparam::json);
    select t.*, pc.project_id
    into t_task_column
    from task.task t
             inner join project.project_column pc on t.project_column_id = pc.id
    where t.id = dto.task_id;

    if not checks.is_project_member(userid, t_task_column.project_id) then
        raise exception 'PERMISSION_DENIED';
    end if;

    insert into task.comment (message, task_id, created_at, created_by)
    values (dto.message, dto.task_id, now(), userid)
    returning id into new_id;

    return new_id;
END
$$;


ALTER FUNCTION task.task_add_comment(dataparam text, userid bigint) OWNER TO postgres;

--
-- Name: task_add_member(bigint, bigint, bigint); Type: FUNCTION; Schema: task; Owner: postgres
--

CREATE FUNCTION task.task_add_member(userid bigint, taskid bigint, session_id bigint) RETURNS bigint
    LANGUAGE plpgsql
    AS $$
declare
    t_session_user auth.auth_user%rowtype;
    target_user    auth.auth_user%rowtype;
    new_member     bigint;
begin
    t_session_user = auth.is_active(session_id);
    target_user = auth.is_active(userid);

    if not t_session_user.organization_id = target_user.organization_id then
        raise exception 'TARGET_USER_NOT_FOUND';
    end if;

    if not (auth.hasanyrole('ADMIN', session_id) OR
            exists(select *
                   from task.task t
                            inner join project.project_column pc on t.project_column_id = pc.id
                            inner join project.project_member pm on pm.project_id = pc.project_id
                   where pm.is_lead
                     and pm.user_id = session_id
                     and t.id = taskid)) then
        raise exception '%',utils.error_message('PERMISSION_DENIED', t_session_user.language);
    end if;

    insert into task.task_member (user_id, task_id, created_by)
    values (userid, taskid, session_id)
    returning id into new_member;

    return new_member;
end
$$;


ALTER FUNCTION task.task_add_member(userid bigint, taskid bigint, session_id bigint) OWNER TO postgres;

--
-- Name: task_change_order(bigint, smallint); Type: PROCEDURE; Schema: task; Owner: postgres
--

CREATE PROCEDURE task.task_change_order(taskid bigint, new_order smallint)
    LANGUAGE plpgsql
    AS $$
DECLARE
    count  smallint;
    t_task task.task%rowtype;
BEGIN
    select t.* into t_task from task.task t where t.id = taskid;
    count = (select count(*) from task.task where project_column_id = t_task.project_column_id and not is_deleted);

    if new_order > count and not new_order = 32000 then
        new_order = count;
    else
        if new_order < 1 then
            new_order = 1;
        end if;
    end if;

    if new_order > t_task."order" then
        update task.task
        set "order" = "order" - 1
        where "order" <= new_order
          and "order" > t_task."order"
          and id <> taskid
          and project_column_id = t_task.project_column_id;

        update task.task
        set "order" = new_order
        where id = taskid;
    end if;

    if new_order < t_task."order" then
        update task.task
        set "order" = "order" + 1
        where "order" >= new_order
          and "order" < t_task."order"
          and id <> taskid
          and project_column_id = t_task.project_column_id;

        update task.task
        set "order" = new_order
        where id = taskid;
    end if;
END
$$;


ALTER PROCEDURE task.task_change_order(taskid bigint, new_order smallint) OWNER TO postgres;

--
-- Name: task_comments(bigint); Type: FUNCTION; Schema: task; Owner: postgres
--

CREATE FUNCTION task.task_comments(taskid bigint) RETURNS text
    LANGUAGE plpgsql
    AS $$
declare
begin
    return (select array_to_json(array_agg((row_to_json("table"))))
            from (select tc.*
                  from task.comment tc
                  where not tc.is_deleted
                    and tc.task_id = taskid) "table");
end
$$;


ALTER FUNCTION task.task_comments(taskid bigint) OWNER TO postgres;

--
-- Name: task_create(text, bigint); Type: FUNCTION; Schema: task; Owner: postgres
--

CREATE FUNCTION task.task_create(dataparam text, userid bigint) RETURNS bigint
    LANGUAGE plpgsql
    AS $$
declare
    t_session_user auth.auth_user%rowtype;
    dto            task.task_create_dto;
    new_id         bigint;
    v_order        smallint;
    v_project_id   bigint;
begin
    --CHECK USER FOR PERMISSION AND ACTIVE
    t_session_user = auth.is_active(userid);
    v_project_id = auth.get_project_id(userid);
    if v_project_id is null or
       not (exists(select * from project.project_member where is_lead and user_id = t_session_user.id)
           or checks.is_project_member(v_project_id, userid)
           or t_session_user.is_super_user
           or auth.hasanyrole('ADMIN', t_session_user.id)) then
        raise exception '%',utils.error_message('PERMISSION_DENIED', t_session_user.language);
    end if;

    --CHECK DATA_PARAM 
    call utils.check_data(data := dataparam);
    dto = mappers.to_task_create_dto(dataparam::json);
    dto = checks.check_task_create_dto(dto);

    --GENERATE ORDER TO LAST 
    select tt."order"
    into v_order
    from task.task tt
    where not tt.is_deleted
      and tt.project_column_id = dto.project_column_id
    order by tt."order" desc
    limit 1;
    if not FOUND then
        v_order = 1;
    else
        v_order = v_order + 1;
    end if;

    --INSERTION
    insert into task.task (name, description, project_column_id, deadline, "order", level, priority, created_by)
    values (dto.name, dto.description, dto.project_column_id, dto.deadline, v_order, dto.level, dto.priority,
            t_session_user.id)
    returning id into new_id;

    return new_id;
end
$$;


ALTER FUNCTION task.task_create(dataparam text, userid bigint) OWNER TO postgres;

--
-- Name: task_delete(bigint, bigint); Type: PROCEDURE; Schema: task; Owner: postgres
--

CREATE PROCEDURE task.task_delete(userid bigint, taskid bigint)
    LANGUAGE plpgsql
    AS $$
declare
    t_session_user auth.auth_user%rowtype;
    t_task         task.task%rowtype;
begin
    t_session_user = auth.is_active(userid);

    select * into t_task from task.task t where not t.is_deleted and t.id = taskid;
    if not FOUND then
        raise exception 'TASK_NOT_FOUND';
    end if;

    if not (t_task.created_by = t_session_user.id or exists(select *
                                                            from task.task_member tm
                                                            where tm.created_by = t_session_user.id)) then
        raise exception '%',utils.error_message('PERMISSION_DENIED', t_session_user.language);
    end if;

    call task.task_change_order(taskid::bigint, 32000::smallint);

    update task.task set is_deleted = true where id = t_task.id;
end
$$;


ALTER PROCEDURE task.task_delete(userid bigint, taskid bigint) OWNER TO postgres;

--
-- Name: task_details(bigint); Type: FUNCTION; Schema: task; Owner: postgres
--

CREATE FUNCTION task.task_details(projectcolumnid bigint) RETURNS jsonb
    LANGUAGE plpgsql
    AS $$
DECLARE
BEGIN
    return (select array_to_json(array_agg(row_to_json("table")))
            from (
                     select t.id,
                            t.name,
                            t.description,
                            t.deadline,
                            task.task_level_val(t.level)       as level,
                            task.task_priority_val(t.priority) as priority,
                            task.task_members_details(t.id)    as members,
                            task.task_comments(t.id) ::jsonb          as comments
                     from task.task t
                     where not t.is_deleted
                       and t.project_column_id = projectcolumnid
                     order by t."order"
                 ) "table");
END
$$;


ALTER FUNCTION task.task_details(projectcolumnid bigint) OWNER TO postgres;

--
-- Name: task_level_val(bigint); Type: FUNCTION; Schema: task; Owner: postgres
--

CREATE FUNCTION task.task_level_val(level bigint) RETURNS character varying
    LANGUAGE plpgsql
    AS $$
begin
    return (select s.value from settings.settings s where s.id = level);
end
$$;


ALTER FUNCTION task.task_level_val(level bigint) OWNER TO postgres;

--
-- Name: task_members_details(bigint); Type: FUNCTION; Schema: task; Owner: postgres
--

CREATE FUNCTION task.task_members_details(taskid bigint) RETURNS jsonb
    LANGUAGE plpgsql
    AS $$
begin
    return (select array_to_json(array_agg(row_to_json(user_table)))
            from (select tm.id memberId, auth.auth_user_info(tm.user_id)::jsonb userInfo
                  from task.task_member tm
                  where tm.task_id = taskid) as user_table);
end
$$;


ALTER FUNCTION task.task_members_details(taskid bigint) OWNER TO postgres;

--
-- Name: task_priority_val(bigint); Type: FUNCTION; Schema: task; Owner: postgres
--

CREATE FUNCTION task.task_priority_val(priority bigint) RETURNS character varying
    LANGUAGE plpgsql
    AS $$
begin
    return (select s.value from settings.settings s where s.id = priority);
end
$$;


ALTER FUNCTION task.task_priority_val(priority bigint) OWNER TO postgres;

--
-- Name: task_update(text, bigint); Type: FUNCTION; Schema: task; Owner: postgres
--

CREATE FUNCTION task.task_update(dataparam text, userid bigint) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
declare
    dto            task.task_update_dto;
    t_session_user auth.auth_user%rowtype;
    v_project_id   bigint;
begin
    --CHECK USER FOR ACTIVE AND PERMISSION
    t_session_user := auth.is_active(userid);
    v_project_id = auth.get_project_id(userid);
    if v_project_id is null or
       not (exists(select * from project.project_member where is_lead and user_id = t_session_user.id)
           or checks.is_project_member(v_project_id, userid)
           or t_session_user.is_super_user
           or auth.hasanyrole('ADMIN', t_session_user.id)) then
        raise exception '%',utils.error_message('PERMISSION_DENIED', t_session_user.language);
    end if;

    select pm.project_id into v_project_id from project.project_member pm where pm.user_id = t_session_user.id;

    --CHECK DATA_PARAM
    call utils.check_data(data := dataparam);
    dto = mappers.to_task_update_dto(dataparam::json);
    dto = checks.check_task_update_dto(dto);

--     if not exists(select * from task.task_member tm where tm.user_id = t_session_user.id and tm.task_id = dto.id) then
--         raise exception 'TASK_NOT_FOUND';
--     end if;

    if not exists(select *
                  from project.project_column pc
                  where pc.id = dto.project_column_id
                    and pc.project_id = v_project_id) then
        raise exception '%',utils.error_message('PERMISSION_DENIED', t_session_user.language);
    end if;

    update task.task
    set name              = dto.name,
        description       = dto.description,
        level             = dto.level,
--         "order"           = dto."order",
        priority          = dto.priority,
        project_column_id = dto.project_column_id,
        deadline          = dto.deadline,
        updated_by        = t_session_user.id,
        updated_at        = now()
    where id = dto.id;

    call task.task_change_order(dto.id,dto."order");

    return true;
end
$$;


ALTER FUNCTION task.task_update(dataparam text, userid bigint) OWNER TO postgres;

--
-- Name: check_data(text); Type: PROCEDURE; Schema: utils; Owner: postgres
--

CREATE PROCEDURE utils.check_data(data text)
    LANGUAGE plpgsql
    AS $$
begin
    if '{}'::text = data or '' = data then
        raise exception 'DATA_IS_INVALID';
    end if;
end
$$;


ALTER PROCEDURE utils.check_data(data text) OWNER TO postgres;

--
-- Name: encode_password(character varying); Type: FUNCTION; Schema: utils; Owner: postgres
--

CREATE FUNCTION utils.encode_password(raw_password character varying) RETURNS character varying
    LANGUAGE plpgsql
    AS $$
begin
    return buildIns.crypt(raw_password, buildIns.gen_salt('bf', 4));
end;
$$;


ALTER FUNCTION utils.encode_password(raw_password character varying) OWNER TO postgres;

--
-- Name: error_message(character varying); Type: FUNCTION; Schema: utils; Owner: postgres
--

CREATE FUNCTION utils.error_message(error_code character varying) RETURNS text
    LANGUAGE plpgsql
    AS $$
declare
begin

    return utils.error_message(error_code, 'RU');
end
$$;


ALTER FUNCTION utils.error_message(error_code character varying) OWNER TO postgres;

--
-- Name: error_message(character varying, character varying); Type: FUNCTION; Schema: utils; Owner: postgres
--

CREATE FUNCTION utils.error_message(error_code character varying, language_code character varying) RETURNS text
    LANGUAGE plpgsql
    AS $$
declare
begin

    return (select mt.text
            from settings.message_translations mt
            WHERE mt.message = error_code
              and mt.language = language_code);
end
$$;


ALTER FUNCTION utils.error_message(error_code character varying, language_code character varying) OWNER TO postgres;

--
-- Name: gen_number(integer); Type: FUNCTION; Schema: utils; Owner: postgres
--

CREATE FUNCTION utils.gen_number(digits_count integer) RETURNS bigint
    LANGUAGE plpgsql
    AS $$
declare
    min int8;
    max int8;
begin
    min = pow(10, digits_count - 1);
    max = pow(10, digits_count) - 1;
    return cast(round(random() * (max - min) + min) as int8);
end
$$;


ALTER FUNCTION utils.gen_number(digits_count integer) OWNER TO postgres;

--
-- Name: isstrongpassword(character varying); Type: FUNCTION; Schema: utils; Owner: postgres
--

CREATE FUNCTION utils.isstrongpassword(raw_password character varying) RETURNS boolean
    LANGUAGE plpgsql
    AS $_$
begin
    return raw_password ~ '^(?=.*[A-Z])(?=.*[!@#$&*_])(?=.*[0-9])(?=.*[a-z].*[a-z].*[a-z]).{8,}$';
end;
$_$;


ALTER FUNCTION utils.isstrongpassword(raw_password character varying) OWNER TO postgres;

--
-- Name: langid_by_code(character varying); Type: FUNCTION; Schema: utils; Owner: postgres
--

CREATE FUNCTION utils.langid_by_code(language_code character varying) RETURNS bigint
    LANGUAGE plpgsql
    AS $$
declare
    v_id bigint;
begin
    select id into v_id from settings.language l where l.code = language_code;
    if FOUND then
        return v_id;
        else
        return (select id from settings.language l where l.code='RU');
    end if;

end ;
$$;


ALTER FUNCTION utils.langid_by_code(language_code character varying) OWNER TO postgres;

--
-- Name: match_password(character varying, character varying); Type: FUNCTION; Schema: utils; Owner: postgres
--

CREATE FUNCTION utils.match_password(raw_password character varying, encoded_password character varying) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
begin
    return encoded_password = buildIns.crypt(raw_password, encoded_password);
end
$$;


ALTER FUNCTION utils.match_password(raw_password character varying, encoded_password character varying) OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: auth_blocked_user; Type: TABLE; Schema: auth; Owner: postgres
--

CREATE TABLE auth.auth_blocked_user (
    id bigint NOT NULL,
    user_id bigint,
    blocked_for character varying,
    blocked_at timestamp with time zone DEFAULT now(),
    blocked_till timestamp with time zone,
    blocked_by bigint,
    is_deleted boolean DEFAULT false
);


ALTER TABLE auth.auth_blocked_user OWNER TO postgres;

--
-- Name: auth_blocked_user_id_seq; Type: SEQUENCE; Schema: auth; Owner: postgres
--

CREATE SEQUENCE auth.auth_blocked_user_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE auth.auth_blocked_user_id_seq OWNER TO postgres;

--
-- Name: auth_blocked_user_id_seq; Type: SEQUENCE OWNED BY; Schema: auth; Owner: postgres
--

ALTER SEQUENCE auth.auth_blocked_user_id_seq OWNED BY auth.auth_blocked_user.id;


--
-- Name: auth_permission; Type: TABLE; Schema: auth; Owner: postgres
--

CREATE TABLE auth.auth_permission (
    id bigint NOT NULL,
    code character varying,
    name character varying
);


ALTER TABLE auth.auth_permission OWNER TO postgres;

--
-- Name: auth_permission_id_seq; Type: SEQUENCE; Schema: auth; Owner: postgres
--

CREATE SEQUENCE auth.auth_permission_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE auth.auth_permission_id_seq OWNER TO postgres;

--
-- Name: auth_permission_id_seq; Type: SEQUENCE OWNED BY; Schema: auth; Owner: postgres
--

ALTER SEQUENCE auth.auth_permission_id_seq OWNED BY auth.auth_permission.id;


--
-- Name: auth_role; Type: TABLE; Schema: auth; Owner: postgres
--

CREATE TABLE auth.auth_role (
    id bigint NOT NULL,
    code character varying,
    name character varying,
    order_value integer DEFAULT 0 NOT NULL
);


ALTER TABLE auth.auth_role OWNER TO postgres;

--
-- Name: auth_role_id_seq; Type: SEQUENCE; Schema: auth; Owner: postgres
--

CREATE SEQUENCE auth.auth_role_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE auth.auth_role_id_seq OWNER TO postgres;

--
-- Name: auth_role_id_seq; Type: SEQUENCE OWNED BY; Schema: auth; Owner: postgres
--

ALTER SEQUENCE auth.auth_role_id_seq OWNED BY auth.auth_role.id;


--
-- Name: auth_role_permission; Type: TABLE; Schema: auth; Owner: postgres
--

CREATE TABLE auth.auth_role_permission (
    role_id bigint,
    permission_id bigint
);


ALTER TABLE auth.auth_role_permission OWNER TO postgres;

--
-- Name: auth_user; Type: TABLE; Schema: auth; Owner: postgres
--

CREATE TABLE auth.auth_user (
    id bigint NOT NULL,
    password character varying NOT NULL,
    code character varying DEFAULT (buildins.gen_random_uuid())::text,
    email character varying NOT NULL,
    phone character varying NOT NULL,
    first_name character varying,
    last_name character varying,
    is_super_user boolean DEFAULT false,
    last_login_time timestamp with time zone,
    login_try_count smallint DEFAULT 0,
    organization_id bigint NOT NULL,
    status smallint DEFAULT '-1'::integer,
    language character varying NOT NULL,
    is_deleted boolean DEFAULT false,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    created_by bigint NOT NULL,
    updated_at timestamp with time zone,
    updated_by bigint,
    username character varying NOT NULL
);


ALTER TABLE auth.auth_user OWNER TO postgres;

--
-- Name: auth_user_id_seq; Type: SEQUENCE; Schema: auth; Owner: postgres
--

CREATE SEQUENCE auth.auth_user_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE auth.auth_user_id_seq OWNER TO postgres;

--
-- Name: auth_user_id_seq; Type: SEQUENCE OWNED BY; Schema: auth; Owner: postgres
--

ALTER SEQUENCE auth.auth_user_id_seq OWNED BY auth.auth_user.id;


--
-- Name: auth_user_permission; Type: TABLE; Schema: auth; Owner: postgres
--

CREATE TABLE auth.auth_user_permission (
    user_id bigint,
    permission_id bigint
);


ALTER TABLE auth.auth_user_permission OWNER TO postgres;

--
-- Name: auth_user_role; Type: TABLE; Schema: auth; Owner: postgres
--

CREATE TABLE auth.auth_user_role (
    user_id bigint,
    role_id bigint
);


ALTER TABLE auth.auth_user_role OWNER TO postgres;

--
-- Name: organization; Type: TABLE; Schema: organization; Owner: postgres
--

CREATE TABLE organization.organization (
    id bigint NOT NULL,
    name character varying NOT NULL,
    website character varying,
    email character varying,
    logo character varying,
    reg_num character varying NOT NULL,
    status smallint DEFAULT 0,
    paid_for timestamp with time zone,
    location point DEFAULT point((2)::double precision, (3)::double precision),
    created_at timestamp with time zone DEFAULT now(),
    created_by bigint,
    is_deleted boolean DEFAULT false
);


ALTER TABLE organization.organization OWNER TO postgres;

--
-- Name: organization_id_seq; Type: SEQUENCE; Schema: organization; Owner: postgres
--

CREATE SEQUENCE organization.organization_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE organization.organization_id_seq OWNER TO postgres;

--
-- Name: organization_id_seq; Type: SEQUENCE OWNED BY; Schema: organization; Owner: postgres
--

ALTER SEQUENCE organization.organization_id_seq OWNED BY organization.organization.id;


--
-- Name: project; Type: TABLE; Schema: project; Owner: postgres
--

CREATE TABLE project.project (
    id bigint NOT NULL,
    name character varying NOT NULL,
    code character varying NOT NULL,
    background character varying,
    is_archived boolean DEFAULT false,
    tz character varying,
    description text,
    organization_id bigint,
    is_deleted boolean DEFAULT false,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    created_by bigint NOT NULL,
    updated_at timestamp with time zone,
    updated_by bigint,
    status smallint DEFAULT 0 NOT NULL
);


ALTER TABLE project.project OWNER TO postgres;

--
-- Name: project_column; Type: TABLE; Schema: project; Owner: postgres
--

CREATE TABLE project.project_column (
    id bigint NOT NULL,
    name character varying,
    emoji character varying,
    project_id bigint,
    "order" smallint,
    is_deleted boolean DEFAULT false,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    created_by bigint NOT NULL,
    updated_at timestamp with time zone,
    updated_by bigint
);


ALTER TABLE project.project_column OWNER TO postgres;

--
-- Name: project_column_id_seq; Type: SEQUENCE; Schema: project; Owner: postgres
--

CREATE SEQUENCE project.project_column_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE project.project_column_id_seq OWNER TO postgres;

--
-- Name: project_column_id_seq; Type: SEQUENCE OWNED BY; Schema: project; Owner: postgres
--

ALTER SEQUENCE project.project_column_id_seq OWNED BY project.project_column.id;


--
-- Name: project_id_seq; Type: SEQUENCE; Schema: project; Owner: postgres
--

CREATE SEQUENCE project.project_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE project.project_id_seq OWNER TO postgres;

--
-- Name: project_id_seq; Type: SEQUENCE OWNED BY; Schema: project; Owner: postgres
--

ALTER SEQUENCE project.project_id_seq OWNED BY project.project.id;


--
-- Name: project_label; Type: TABLE; Schema: project; Owner: postgres
--

CREATE TABLE project.project_label (
    id bigint NOT NULL,
    text character varying,
    color character varying NOT NULL,
    project_id bigint,
    is_deleted boolean DEFAULT false,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    created_by bigint NOT NULL,
    updated_at timestamp with time zone,
    updated_by bigint
);


ALTER TABLE project.project_label OWNER TO postgres;

--
-- Name: project_label_id_seq; Type: SEQUENCE; Schema: project; Owner: postgres
--

ALTER TABLE project.project_label ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME project.project_label_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    MAXVALUE 2147483647
    CACHE 1
);


--
-- Name: project_member; Type: TABLE; Schema: project; Owner: postgres
--

CREATE TABLE project.project_member (
    id bigint NOT NULL,
    project_id bigint,
    user_id bigint,
    is_lead boolean DEFAULT false,
    is_deleted boolean DEFAULT false,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    created_by bigint NOT NULL,
    updated_at timestamp with time zone,
    updated_by bigint
);


ALTER TABLE project.project_member OWNER TO postgres;

--
-- Name: project_member_id_seq; Type: SEQUENCE; Schema: project; Owner: postgres
--

ALTER TABLE project.project_member ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME project.project_member_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: language; Type: TABLE; Schema: settings; Owner: postgres
--

CREATE TABLE settings.language (
    id bigint NOT NULL,
    name character varying,
    code character varying NOT NULL
);


ALTER TABLE settings.language OWNER TO postgres;

--
-- Name: language_id_seq; Type: SEQUENCE; Schema: settings; Owner: postgres
--

CREATE SEQUENCE settings.language_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE settings.language_id_seq OWNER TO postgres;

--
-- Name: language_id_seq; Type: SEQUENCE OWNED BY; Schema: settings; Owner: postgres
--

ALTER SEQUENCE settings.language_id_seq OWNED BY settings.language.id;


--
-- Name: message; Type: TABLE; Schema: settings; Owner: postgres
--

CREATE TABLE settings.message (
    id bigint NOT NULL,
    code character varying NOT NULL,
    is_deleted boolean DEFAULT false,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    created_by bigint NOT NULL,
    updated_at timestamp with time zone,
    updated_by bigint
);


ALTER TABLE settings.message OWNER TO postgres;

--
-- Name: message_id_seq; Type: SEQUENCE; Schema: settings; Owner: postgres
--

CREATE SEQUENCE settings.message_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE settings.message_id_seq OWNER TO postgres;

--
-- Name: message_id_seq; Type: SEQUENCE OWNED BY; Schema: settings; Owner: postgres
--

ALTER SEQUENCE settings.message_id_seq OWNED BY settings.message.id;


--
-- Name: message_translations; Type: TABLE; Schema: settings; Owner: postgres
--

CREATE TABLE settings.message_translations (
    id bigint NOT NULL,
    message character varying,
    language character varying,
    text character varying NOT NULL
);


ALTER TABLE settings.message_translations OWNER TO postgres;

--
-- Name: message_translations_id_seq; Type: SEQUENCE; Schema: settings; Owner: postgres
--

CREATE SEQUENCE settings.message_translations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE settings.message_translations_id_seq OWNER TO postgres;

--
-- Name: message_translations_id_seq; Type: SEQUENCE OWNED BY; Schema: settings; Owner: postgres
--

ALTER SEQUENCE settings.message_translations_id_seq OWNED BY settings.message_translations.id;


--
-- Name: settings; Type: TABLE; Schema: settings; Owner: postgres
--

CREATE TABLE settings.settings (
    id bigint NOT NULL,
    code character varying,
    value character varying
);


ALTER TABLE settings.settings OWNER TO postgres;

--
-- Name: settings_id_seq; Type: SEQUENCE; Schema: settings; Owner: postgres
--

CREATE SEQUENCE settings.settings_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE settings.settings_id_seq OWNER TO postgres;

--
-- Name: settings_id_seq; Type: SEQUENCE OWNED BY; Schema: settings; Owner: postgres
--

ALTER SEQUENCE settings.settings_id_seq OWNED BY settings.settings.id;


--
-- Name: comment; Type: TABLE; Schema: task; Owner: postgres
--

CREATE TABLE task.comment (
    id bigint NOT NULL,
    message text,
    type bigint,
    task_id bigint,
    is_deleted boolean DEFAULT false,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    created_by bigint NOT NULL,
    updated_at timestamp with time zone,
    updated_by bigint
);


ALTER TABLE task.comment OWNER TO postgres;

--
-- Name: comment_id_seq; Type: SEQUENCE; Schema: task; Owner: postgres
--

CREATE SEQUENCE task.comment_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE task.comment_id_seq OWNER TO postgres;

--
-- Name: comment_id_seq; Type: SEQUENCE OWNED BY; Schema: task; Owner: postgres
--

ALTER SEQUENCE task.comment_id_seq OWNED BY task.comment.id;


--
-- Name: task; Type: TABLE; Schema: task; Owner: postgres
--

CREATE TABLE task.task (
    id bigint NOT NULL,
    name character varying NOT NULL,
    description text,
    project_column_id bigint,
    deadline timestamp with time zone,
    "order" smallint,
    level bigint,
    priority bigint,
    is_deleted boolean DEFAULT false,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    created_by bigint NOT NULL,
    updated_at timestamp with time zone,
    updated_by bigint
);


ALTER TABLE task.task OWNER TO postgres;

--
-- Name: task_id_seq; Type: SEQUENCE; Schema: task; Owner: postgres
--

CREATE SEQUENCE task.task_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE task.task_id_seq OWNER TO postgres;

--
-- Name: task_id_seq; Type: SEQUENCE OWNED BY; Schema: task; Owner: postgres
--

ALTER SEQUENCE task.task_id_seq OWNED BY task.task.id;


--
-- Name: task_member; Type: TABLE; Schema: task; Owner: postgres
--

CREATE TABLE task.task_member (
    id bigint NOT NULL,
    user_id bigint,
    task_id bigint,
    is_deleted boolean DEFAULT false,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    created_by bigint NOT NULL,
    updated_at timestamp with time zone,
    updated_by bigint
);


ALTER TABLE task.task_member OWNER TO postgres;

--
-- Name: task_member_id_seq; Type: SEQUENCE; Schema: task; Owner: postgres
--

CREATE SEQUENCE task.task_member_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE task.task_member_id_seq OWNER TO postgres;

--
-- Name: task_member_id_seq; Type: SEQUENCE OWNED BY; Schema: task; Owner: postgres
--

ALTER SEQUENCE task.task_member_id_seq OWNED BY task.task_member.id;


--
-- Name: auth_blocked_user id; Type: DEFAULT; Schema: auth; Owner: postgres
--

ALTER TABLE ONLY auth.auth_blocked_user ALTER COLUMN id SET DEFAULT nextval('auth.auth_blocked_user_id_seq'::regclass);


--
-- Name: auth_permission id; Type: DEFAULT; Schema: auth; Owner: postgres
--

ALTER TABLE ONLY auth.auth_permission ALTER COLUMN id SET DEFAULT nextval('auth.auth_permission_id_seq'::regclass);


--
-- Name: auth_role id; Type: DEFAULT; Schema: auth; Owner: postgres
--

ALTER TABLE ONLY auth.auth_role ALTER COLUMN id SET DEFAULT nextval('auth.auth_role_id_seq'::regclass);


--
-- Name: auth_user id; Type: DEFAULT; Schema: auth; Owner: postgres
--

ALTER TABLE ONLY auth.auth_user ALTER COLUMN id SET DEFAULT nextval('auth.auth_user_id_seq'::regclass);


--
-- Name: organization id; Type: DEFAULT; Schema: organization; Owner: postgres
--

ALTER TABLE ONLY organization.organization ALTER COLUMN id SET DEFAULT nextval('organization.organization_id_seq'::regclass);


--
-- Name: project id; Type: DEFAULT; Schema: project; Owner: postgres
--

ALTER TABLE ONLY project.project ALTER COLUMN id SET DEFAULT nextval('project.project_id_seq'::regclass);


--
-- Name: project_column id; Type: DEFAULT; Schema: project; Owner: postgres
--

ALTER TABLE ONLY project.project_column ALTER COLUMN id SET DEFAULT nextval('project.project_column_id_seq'::regclass);


--
-- Name: language id; Type: DEFAULT; Schema: settings; Owner: postgres
--

ALTER TABLE ONLY settings.language ALTER COLUMN id SET DEFAULT nextval('settings.language_id_seq'::regclass);


--
-- Name: message id; Type: DEFAULT; Schema: settings; Owner: postgres
--

ALTER TABLE ONLY settings.message ALTER COLUMN id SET DEFAULT nextval('settings.message_id_seq'::regclass);


--
-- Name: message_translations id; Type: DEFAULT; Schema: settings; Owner: postgres
--

ALTER TABLE ONLY settings.message_translations ALTER COLUMN id SET DEFAULT nextval('settings.message_translations_id_seq'::regclass);


--
-- Name: settings id; Type: DEFAULT; Schema: settings; Owner: postgres
--

ALTER TABLE ONLY settings.settings ALTER COLUMN id SET DEFAULT nextval('settings.settings_id_seq'::regclass);


--
-- Name: comment id; Type: DEFAULT; Schema: task; Owner: postgres
--

ALTER TABLE ONLY task.comment ALTER COLUMN id SET DEFAULT nextval('task.comment_id_seq'::regclass);


--
-- Name: task id; Type: DEFAULT; Schema: task; Owner: postgres
--

ALTER TABLE ONLY task.task ALTER COLUMN id SET DEFAULT nextval('task.task_id_seq'::regclass);


--
-- Name: task_member id; Type: DEFAULT; Schema: task; Owner: postgres
--

ALTER TABLE ONLY task.task_member ALTER COLUMN id SET DEFAULT nextval('task.task_member_id_seq'::regclass);


--
-- Data for Name: auth_blocked_user; Type: TABLE DATA; Schema: auth; Owner: postgres
--

COPY auth.auth_blocked_user (id, user_id, blocked_for, blocked_at, blocked_till, blocked_by, is_deleted) FROM stdin;
\.
COPY auth.auth_blocked_user (id, user_id, blocked_for, blocked_at, blocked_till, blocked_by, is_deleted) FROM '$$PATH$$/3386.dat';

--
-- Data for Name: auth_permission; Type: TABLE DATA; Schema: auth; Owner: postgres
--

COPY auth.auth_permission (id, code, name) FROM stdin;
\.
COPY auth.auth_permission (id, code, name) FROM '$$PATH$$/3388.dat';

--
-- Data for Name: auth_role; Type: TABLE DATA; Schema: auth; Owner: postgres
--

COPY auth.auth_role (id, code, name, order_value) FROM stdin;
\.
COPY auth.auth_role (id, code, name, order_value) FROM '$$PATH$$/3390.dat';

--
-- Data for Name: auth_role_permission; Type: TABLE DATA; Schema: auth; Owner: postgres
--

COPY auth.auth_role_permission (role_id, permission_id) FROM stdin;
\.
COPY auth.auth_role_permission (role_id, permission_id) FROM '$$PATH$$/3392.dat';

--
-- Data for Name: auth_user; Type: TABLE DATA; Schema: auth; Owner: postgres
--

COPY auth.auth_user (id, password, code, email, phone, first_name, last_name, is_super_user, last_login_time, login_try_count, organization_id, status, language, is_deleted, created_at, created_by, updated_at, updated_by, username) FROM stdin;
\.
COPY auth.auth_user (id, password, code, email, phone, first_name, last_name, is_super_user, last_login_time, login_try_count, organization_id, status, language, is_deleted, created_at, created_by, updated_at, updated_by, username) FROM '$$PATH$$/3393.dat';

--
-- Data for Name: auth_user_permission; Type: TABLE DATA; Schema: auth; Owner: postgres
--

COPY auth.auth_user_permission (user_id, permission_id) FROM stdin;
\.
COPY auth.auth_user_permission (user_id, permission_id) FROM '$$PATH$$/3395.dat';

--
-- Data for Name: auth_user_role; Type: TABLE DATA; Schema: auth; Owner: postgres
--

COPY auth.auth_user_role (user_id, role_id) FROM stdin;
\.
COPY auth.auth_user_role (user_id, role_id) FROM '$$PATH$$/3396.dat';

--
-- Data for Name: organization; Type: TABLE DATA; Schema: organization; Owner: postgres
--

COPY organization.organization (id, name, website, email, logo, reg_num, status, paid_for, location, created_at, created_by, is_deleted) FROM stdin;
\.
COPY organization.organization (id, name, website, email, logo, reg_num, status, paid_for, location, created_at, created_by, is_deleted) FROM '$$PATH$$/3397.dat';

--
-- Data for Name: project; Type: TABLE DATA; Schema: project; Owner: postgres
--

COPY project.project (id, name, code, background, is_archived, tz, description, organization_id, is_deleted, created_at, created_by, updated_at, updated_by, status) FROM stdin;
\.
COPY project.project (id, name, code, background, is_archived, tz, description, organization_id, is_deleted, created_at, created_by, updated_at, updated_by, status) FROM '$$PATH$$/3399.dat';

--
-- Data for Name: project_column; Type: TABLE DATA; Schema: project; Owner: postgres
--

COPY project.project_column (id, name, emoji, project_id, "order", is_deleted, created_at, created_by, updated_at, updated_by) FROM stdin;
\.
COPY project.project_column (id, name, emoji, project_id, "order", is_deleted, created_at, created_by, updated_at, updated_by) FROM '$$PATH$$/3400.dat';

--
-- Data for Name: project_label; Type: TABLE DATA; Schema: project; Owner: postgres
--

COPY project.project_label (id, text, color, project_id, is_deleted, created_at, created_by, updated_at, updated_by) FROM stdin;
\.
COPY project.project_label (id, text, color, project_id, is_deleted, created_at, created_by, updated_at, updated_by) FROM '$$PATH$$/3403.dat';

--
-- Data for Name: project_member; Type: TABLE DATA; Schema: project; Owner: postgres
--

COPY project.project_member (id, project_id, user_id, is_lead, is_deleted, created_at, created_by, updated_at, updated_by) FROM stdin;
\.
COPY project.project_member (id, project_id, user_id, is_lead, is_deleted, created_at, created_by, updated_at, updated_by) FROM '$$PATH$$/3405.dat';

--
-- Data for Name: language; Type: TABLE DATA; Schema: settings; Owner: postgres
--

COPY settings.language (id, name, code) FROM stdin;
\.
COPY settings.language (id, name, code) FROM '$$PATH$$/3407.dat';

--
-- Data for Name: message; Type: TABLE DATA; Schema: settings; Owner: postgres
--

COPY settings.message (id, code, is_deleted, created_at, created_by, updated_at, updated_by) FROM stdin;
\.
COPY settings.message (id, code, is_deleted, created_at, created_by, updated_at, updated_by) FROM '$$PATH$$/3409.dat';

--
-- Data for Name: message_translations; Type: TABLE DATA; Schema: settings; Owner: postgres
--

COPY settings.message_translations (id, message, language, text) FROM stdin;
\.
COPY settings.message_translations (id, message, language, text) FROM '$$PATH$$/3411.dat';

--
-- Data for Name: settings; Type: TABLE DATA; Schema: settings; Owner: postgres
--

COPY settings.settings (id, code, value) FROM stdin;
\.
COPY settings.settings (id, code, value) FROM '$$PATH$$/3413.dat';

--
-- Data for Name: comment; Type: TABLE DATA; Schema: task; Owner: postgres
--

COPY task.comment (id, message, type, task_id, is_deleted, created_at, created_by, updated_at, updated_by) FROM stdin;
\.
COPY task.comment (id, message, type, task_id, is_deleted, created_at, created_by, updated_at, updated_by) FROM '$$PATH$$/3415.dat';

--
-- Data for Name: task; Type: TABLE DATA; Schema: task; Owner: postgres
--

COPY task.task (id, name, description, project_column_id, deadline, "order", level, priority, is_deleted, created_at, created_by, updated_at, updated_by) FROM stdin;
\.
COPY task.task (id, name, description, project_column_id, deadline, "order", level, priority, is_deleted, created_at, created_by, updated_at, updated_by) FROM '$$PATH$$/3417.dat';

--
-- Data for Name: task_member; Type: TABLE DATA; Schema: task; Owner: postgres
--

COPY task.task_member (id, user_id, task_id, is_deleted, created_at, created_by, updated_at, updated_by) FROM stdin;
\.
COPY task.task_member (id, user_id, task_id, is_deleted, created_at, created_by, updated_at, updated_by) FROM '$$PATH$$/3419.dat';

--
-- Name: auth_blocked_user_id_seq; Type: SEQUENCE SET; Schema: auth; Owner: postgres
--

SELECT pg_catalog.setval('auth.auth_blocked_user_id_seq', 9, true);


--
-- Name: auth_permission_id_seq; Type: SEQUENCE SET; Schema: auth; Owner: postgres
--

SELECT pg_catalog.setval('auth.auth_permission_id_seq', 213, true);


--
-- Name: auth_role_id_seq; Type: SEQUENCE SET; Schema: auth; Owner: postgres
--

SELECT pg_catalog.setval('auth.auth_role_id_seq', 4, true);


--
-- Name: auth_user_id_seq; Type: SEQUENCE SET; Schema: auth; Owner: postgres
--

SELECT pg_catalog.setval('auth.auth_user_id_seq', 4, true);


--
-- Name: organization_id_seq; Type: SEQUENCE SET; Schema: organization; Owner: postgres
--

SELECT pg_catalog.setval('organization.organization_id_seq', 4, true);


--
-- Name: project_column_id_seq; Type: SEQUENCE SET; Schema: project; Owner: postgres
--

SELECT pg_catalog.setval('project.project_column_id_seq', 3, true);


--
-- Name: project_id_seq; Type: SEQUENCE SET; Schema: project; Owner: postgres
--

SELECT pg_catalog.setval('project.project_id_seq', 3, true);


--
-- Name: project_label_id_seq; Type: SEQUENCE SET; Schema: project; Owner: postgres
--

SELECT pg_catalog.setval('project.project_label_id_seq', 9, true);


--
-- Name: project_member_id_seq; Type: SEQUENCE SET; Schema: project; Owner: postgres
--

SELECT pg_catalog.setval('project.project_member_id_seq', 8, true);


--
-- Name: language_id_seq; Type: SEQUENCE SET; Schema: settings; Owner: postgres
--

SELECT pg_catalog.setval('settings.language_id_seq', 3, true);


--
-- Name: message_id_seq; Type: SEQUENCE SET; Schema: settings; Owner: postgres
--

SELECT pg_catalog.setval('settings.message_id_seq', 7, true);


--
-- Name: message_translations_id_seq; Type: SEQUENCE SET; Schema: settings; Owner: postgres
--

SELECT pg_catalog.setval('settings.message_translations_id_seq', 10, true);


--
-- Name: settings_id_seq; Type: SEQUENCE SET; Schema: settings; Owner: postgres
--

SELECT pg_catalog.setval('settings.settings_id_seq', 6, true);


--
-- Name: comment_id_seq; Type: SEQUENCE SET; Schema: task; Owner: postgres
--

SELECT pg_catalog.setval('task.comment_id_seq', 2, true);


--
-- Name: task_id_seq; Type: SEQUENCE SET; Schema: task; Owner: postgres
--

SELECT pg_catalog.setval('task.task_id_seq', 2, true);


--
-- Name: task_member_id_seq; Type: SEQUENCE SET; Schema: task; Owner: postgres
--

SELECT pg_catalog.setval('task.task_member_id_seq', 2, true);


--
-- Name: auth_blocked_user auth_blocked_user_pkey; Type: CONSTRAINT; Schema: auth; Owner: postgres
--

ALTER TABLE ONLY auth.auth_blocked_user
    ADD CONSTRAINT auth_blocked_user_pkey PRIMARY KEY (id);


--
-- Name: auth_permission auth_permission_pkey; Type: CONSTRAINT; Schema: auth; Owner: postgres
--

ALTER TABLE ONLY auth.auth_permission
    ADD CONSTRAINT auth_permission_pkey PRIMARY KEY (id);


--
-- Name: auth_role auth_role_pkey; Type: CONSTRAINT; Schema: auth; Owner: postgres
--

ALTER TABLE ONLY auth.auth_role
    ADD CONSTRAINT auth_role_pkey PRIMARY KEY (id);


--
-- Name: auth_user auth_user_email_key; Type: CONSTRAINT; Schema: auth; Owner: postgres
--

ALTER TABLE ONLY auth.auth_user
    ADD CONSTRAINT auth_user_email_key UNIQUE (email);


--
-- Name: auth_user auth_user_phone_key; Type: CONSTRAINT; Schema: auth; Owner: postgres
--

ALTER TABLE ONLY auth.auth_user
    ADD CONSTRAINT auth_user_phone_key UNIQUE (phone);


--
-- Name: auth_user auth_user_pkey; Type: CONSTRAINT; Schema: auth; Owner: postgres
--

ALTER TABLE ONLY auth.auth_user
    ADD CONSTRAINT auth_user_pkey PRIMARY KEY (id);


--
-- Name: auth_user auth_user_username_key; Type: CONSTRAINT; Schema: auth; Owner: postgres
--

ALTER TABLE ONLY auth.auth_user
    ADD CONSTRAINT auth_user_username_key UNIQUE (username);


--
-- Name: organization organization_name_key; Type: CONSTRAINT; Schema: organization; Owner: postgres
--

ALTER TABLE ONLY organization.organization
    ADD CONSTRAINT organization_name_key UNIQUE (name);


--
-- Name: organization organization_pkey; Type: CONSTRAINT; Schema: organization; Owner: postgres
--

ALTER TABLE ONLY organization.organization
    ADD CONSTRAINT organization_pkey PRIMARY KEY (id);


--
-- Name: project_column project_column_pkey; Type: CONSTRAINT; Schema: project; Owner: postgres
--

ALTER TABLE ONLY project.project_column
    ADD CONSTRAINT project_column_pkey PRIMARY KEY (id);


--
-- Name: project_label project_label_pkey; Type: CONSTRAINT; Schema: project; Owner: postgres
--

ALTER TABLE ONLY project.project_label
    ADD CONSTRAINT project_label_pkey PRIMARY KEY (id);


--
-- Name: project_member project_member_pkey; Type: CONSTRAINT; Schema: project; Owner: postgres
--

ALTER TABLE ONLY project.project_member
    ADD CONSTRAINT project_member_pkey PRIMARY KEY (id);


--
-- Name: project project_pkey; Type: CONSTRAINT; Schema: project; Owner: postgres
--

ALTER TABLE ONLY project.project
    ADD CONSTRAINT project_pkey PRIMARY KEY (id);


--
-- Name: language language_code_key; Type: CONSTRAINT; Schema: settings; Owner: postgres
--

ALTER TABLE ONLY settings.language
    ADD CONSTRAINT language_code_key UNIQUE (code);


--
-- Name: language language_pkey; Type: CONSTRAINT; Schema: settings; Owner: postgres
--

ALTER TABLE ONLY settings.language
    ADD CONSTRAINT language_pkey PRIMARY KEY (id);


--
-- Name: message message_code_key; Type: CONSTRAINT; Schema: settings; Owner: postgres
--

ALTER TABLE ONLY settings.message
    ADD CONSTRAINT message_code_key UNIQUE (code);


--
-- Name: message message_pkey; Type: CONSTRAINT; Schema: settings; Owner: postgres
--

ALTER TABLE ONLY settings.message
    ADD CONSTRAINT message_pkey PRIMARY KEY (id);


--
-- Name: message_translations message_translations_pkey; Type: CONSTRAINT; Schema: settings; Owner: postgres
--

ALTER TABLE ONLY settings.message_translations
    ADD CONSTRAINT message_translations_pkey PRIMARY KEY (id);


--
-- Name: settings settings_pkey; Type: CONSTRAINT; Schema: settings; Owner: postgres
--

ALTER TABLE ONLY settings.settings
    ADD CONSTRAINT settings_pkey PRIMARY KEY (id);


--
-- Name: comment comment_pkey; Type: CONSTRAINT; Schema: task; Owner: postgres
--

ALTER TABLE ONLY task.comment
    ADD CONSTRAINT comment_pkey PRIMARY KEY (id);


--
-- Name: task_member task_member_pkey; Type: CONSTRAINT; Schema: task; Owner: postgres
--

ALTER TABLE ONLY task.task_member
    ADD CONSTRAINT task_member_pkey PRIMARY KEY (id);


--
-- Name: task task_pkey; Type: CONSTRAINT; Schema: task; Owner: postgres
--

ALTER TABLE ONLY task.task
    ADD CONSTRAINT task_pkey PRIMARY KEY (id);


--
-- Name: auth_blocked_user auth_blocked_user_message_code_fk; Type: FK CONSTRAINT; Schema: auth; Owner: postgres
--

ALTER TABLE ONLY auth.auth_blocked_user
    ADD CONSTRAINT auth_blocked_user_message_code_fk FOREIGN KEY (blocked_for) REFERENCES settings.message(code);


--
-- Name: auth_role_permission auth_role_permission_permission_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: postgres
--

ALTER TABLE ONLY auth.auth_role_permission
    ADD CONSTRAINT auth_role_permission_permission_id_fkey FOREIGN KEY (permission_id) REFERENCES auth.auth_permission(id);


--
-- Name: auth_role_permission auth_role_permission_role_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: postgres
--

ALTER TABLE ONLY auth.auth_role_permission
    ADD CONSTRAINT auth_role_permission_role_id_fkey FOREIGN KEY (role_id) REFERENCES auth.auth_role(id);


--
-- Name: auth_user_permission auth_user_permission_permission_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: postgres
--

ALTER TABLE ONLY auth.auth_user_permission
    ADD CONSTRAINT auth_user_permission_permission_id_fkey FOREIGN KEY (permission_id) REFERENCES auth.auth_permission(id);


--
-- Name: auth_user_permission auth_user_permission_user_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: postgres
--

ALTER TABLE ONLY auth.auth_user_permission
    ADD CONSTRAINT auth_user_permission_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.auth_user(id);


--
-- Name: auth_user_role auth_user_role_role_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: postgres
--

ALTER TABLE ONLY auth.auth_user_role
    ADD CONSTRAINT auth_user_role_role_id_fkey FOREIGN KEY (role_id) REFERENCES auth.auth_role(id);


--
-- Name: auth_user_role auth_user_role_user_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: postgres
--

ALTER TABLE ONLY auth.auth_user_role
    ADD CONSTRAINT auth_user_role_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.auth_user(id);


--
-- Name: project_column project_column_project_id_fkey; Type: FK CONSTRAINT; Schema: project; Owner: postgres
--

ALTER TABLE ONLY project.project_column
    ADD CONSTRAINT project_column_project_id_fkey FOREIGN KEY (project_id) REFERENCES project.project(id);


--
-- Name: project_member project_member_project_id_fkey; Type: FK CONSTRAINT; Schema: project; Owner: postgres
--

ALTER TABLE ONLY project.project_member
    ADD CONSTRAINT project_member_project_id_fkey FOREIGN KEY (project_id) REFERENCES project.project(id);


--
-- Name: project_member project_member_user_id_fkey; Type: FK CONSTRAINT; Schema: project; Owner: postgres
--

ALTER TABLE ONLY project.project_member
    ADD CONSTRAINT project_member_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.auth_user(id);


--
-- Name: project project_organization_id_fkey; Type: FK CONSTRAINT; Schema: project; Owner: postgres
--

ALTER TABLE ONLY project.project
    ADD CONSTRAINT project_organization_id_fkey FOREIGN KEY (organization_id) REFERENCES organization.organization(id);


--
-- Name: message_translations message_translations_language_code_fk; Type: FK CONSTRAINT; Schema: settings; Owner: postgres
--

ALTER TABLE ONLY settings.message_translations
    ADD CONSTRAINT message_translations_language_code_fk FOREIGN KEY (language) REFERENCES settings.language(code);


--
-- Name: message_translations message_translations_message_code_fk; Type: FK CONSTRAINT; Schema: settings; Owner: postgres
--

ALTER TABLE ONLY settings.message_translations
    ADD CONSTRAINT message_translations_message_code_fk FOREIGN KEY (message) REFERENCES settings.message(code);


--
-- Name: comment comment_task_id_fkey; Type: FK CONSTRAINT; Schema: task; Owner: postgres
--

ALTER TABLE ONLY task.comment
    ADD CONSTRAINT comment_task_id_fkey FOREIGN KEY (task_id) REFERENCES task.task(id);


--
-- Name: task_member task_member_task_id_fkey; Type: FK CONSTRAINT; Schema: task; Owner: postgres
--

ALTER TABLE ONLY task.task_member
    ADD CONSTRAINT task_member_task_id_fkey FOREIGN KEY (task_id) REFERENCES task.task(id);


--
-- Name: task_member task_member_user_id_fkey; Type: FK CONSTRAINT; Schema: task; Owner: postgres
--

ALTER TABLE ONLY task.task_member
    ADD CONSTRAINT task_member_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.auth_user(id);


--
-- Name: task task_project_column_id_fkey; Type: FK CONSTRAINT; Schema: task; Owner: postgres
--

ALTER TABLE ONLY task.task
    ADD CONSTRAINT task_project_column_id_fkey FOREIGN KEY (project_column_id) REFERENCES project.project_column(id);


--
-- PostgreSQL database dump complete
--

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       